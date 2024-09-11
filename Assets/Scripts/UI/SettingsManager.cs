using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Rendering.PostProcessing;
using TMPro;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using Cinemachine;

public class SettingsManager : MonoBehaviour
{
    // Default values
    [SerializeField] private float defaultSensitivity = 2f; // 0.1 to 10
    [SerializeField] private float defaultFOV = 60f; // 40 to 90
    [SerializeField] private float defaultBrightness = 0f; // -100 to 100
    [SerializeField] private float defaultVolume = 0f; // esta en dB
    [SerializeField] private int defaultQualityLevel = 3; // Medium Quality

    // UI Elements (TextMeshPro)
    [SerializeField] private TMP_Dropdown qualityDropdown;
    [SerializeField] private Slider masterVolumeSlider;
    [SerializeField] private Slider musicVolumeSlider;
    [SerializeField] private Slider sfxVolumeSlider;
    [SerializeField] private Slider uiVolumeSlider;
    [SerializeField] private Slider brightnessSlider;
    [SerializeField] private Slider sensitivitySlider;
    [SerializeField] private Slider fovSlider;
    [SerializeField] private Slider ambientVolumeSlider; // New slider for ambient sound
    [SerializeField] private TMP_Dropdown resolutionDropdown; // Dropdown for resolution
    [SerializeField] private Toggle fullscreenToggle; // Toggle for fullscreen

    // Audio Mixer
    [SerializeField] private AudioMixer audioMixer;

    // Exposed parameters in the AudioMixer
    private const string masterVolumeParam = "MasterVolume";
    private const string musicVolumeParam = "MusicVolume";
    private const string ambientVolumeParam = "AmbientVolume"; // New parameter for ambient sound
    private const string sfxVolumeParam = "SfxVolume";
    private const string uiVolumeParam = "UiVolume";

    // PostProcessing
    [SerializeField] private PostProcessVolume postProcessVolume;

    // Camera
    [SerializeField] private CinemachineVirtualCamera playerCamera;

    // Internal references
    private ColorGrading colorGrading;
    private GravityPlayerController playerController;

    [SerializeField] private Resolution[] availableResolutions;

    private void Start()
    {
        // Set ranges for sliders
        sensitivitySlider.minValue = 0.1f;
        sensitivitySlider.maxValue = 10f;

        fovSlider.minValue = 40f;
        fovSlider.maxValue = 80f;

        brightnessSlider.minValue = -70f;
        brightnessSlider.maxValue = 80f;

        masterVolumeSlider.minValue = 0f;
        masterVolumeSlider.maxValue = 1f;

        musicVolumeSlider.minValue = 0f;
        musicVolumeSlider.maxValue = 1f;

        sfxVolumeSlider.minValue = 0f;
        sfxVolumeSlider.maxValue = 1f;

        uiVolumeSlider.minValue = 0f;
        uiVolumeSlider.maxValue = 1f;

        ambientVolumeSlider.minValue = 0f; 
        ambientVolumeSlider.maxValue = 1f;

        // Initialize UI with current settings
        InitializeGraphicsSettings();
        InitializeAudioSettings();
        InitializePostProcessingSettings();
        InitializeControlSettings();

        if (PlayerPrefs.GetInt("FirstTimeRun", 1) == 1)
        {
            // Set the resolution to the highest available and enable fullscreen
            SetMaxResolution();

            // Mark as not the first time run
            PlayerPrefs.SetInt("FirstTimeRun", 0);
            PlayerPrefs.Save();

            ResetSettings();
        }
        else
        {
            // Load saved settings
            LoadSettings();
        }
    }

    private void InitializeGraphicsSettings()
    {
        // Set the quality dropdown to current quality level
        qualityDropdown.value = QualitySettings.GetQualityLevel();
        qualityDropdown.onValueChanged.AddListener(ChangeQuality);

        // Initialize resolutions and populate dropdown
        availableResolutions = Screen.resolutions;
        resolutionDropdown.ClearOptions();
        List<string> resolutionOptions = new List<string>();
        int currentResolutionIndex = 0;

        for (int i = 0; i < availableResolutions.Length; i++)
        {
            string option = availableResolutions[i].width + " x " + availableResolutions[i].height;
            resolutionOptions.Add(option);

            if (availableResolutions[i].width == Screen.currentResolution.width && availableResolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = i;
            }
        }

        resolutionDropdown.AddOptions(resolutionOptions);
        resolutionDropdown.value = currentResolutionIndex;
        resolutionDropdown.RefreshShownValue();
        resolutionDropdown.onValueChanged.AddListener(ChangeResolution);

        // Fullscreen toggle
        fullscreenToggle.isOn = Screen.fullScreen;
        fullscreenToggle.onValueChanged.AddListener(SetFullScreen);
    }

    private void InitializeAudioSettings()
    {
        // Get the current volume from the AudioMixer and set the sliders
        float volume;

        audioMixer.GetFloat(masterVolumeParam, out volume);
        masterVolumeSlider.value = volume;
        masterVolumeSlider.onValueChanged.AddListener(SetMasterVolume);

        audioMixer.GetFloat(musicVolumeParam, out volume);
        musicVolumeSlider.value = volume;
        musicVolumeSlider.onValueChanged.AddListener(SetMusicVolume);

        audioMixer.GetFloat(sfxVolumeParam, out volume);
        sfxVolumeSlider.value = volume;
        sfxVolumeSlider.onValueChanged.AddListener(SetSFXVolume);

        audioMixer.GetFloat(uiVolumeParam, out volume);
        uiVolumeSlider.value = volume;
        uiVolumeSlider.onValueChanged.AddListener(SetUIVolume);

        audioMixer.GetFloat(ambientVolumeParam, out volume); // Initialize ambient volume
        ambientVolumeSlider.value = volume;
        ambientVolumeSlider.onValueChanged.AddListener(SetAmbientVolume);
    }

    private void InitializePostProcessingSettings()
    {
        // Access the ColorGrading settings from the PostProcessVolume
        if (postProcessVolume != null && postProcessVolume.profile.TryGetSettings(out colorGrading))
        {
            brightnessSlider.value = Mathf.Clamp(colorGrading.postExposure.value, brightnessSlider.minValue, brightnessSlider.maxValue);
            brightnessSlider.onValueChanged.AddListener(SetBrightness);
        }
    }

    private void InitializeControlSettings()
    {
        // Initialize sensitivity
        sensitivitySlider.value = Mathf.Clamp(defaultSensitivity, sensitivitySlider.minValue, sensitivitySlider.maxValue);
        sensitivitySlider.onValueChanged.AddListener(SetSensitivity);

        // Initialize FOV
        fovSlider.value = Mathf.Clamp(defaultFOV, fovSlider.minValue, fovSlider.maxValue);
        fovSlider.onValueChanged.AddListener(SetFOV);
    }

    // Method to change graphics quality
    public void ChangeQuality(int index)
    {
        QualitySettings.SetQualityLevel(index);
    }

    // Methods to set volumes
    public void SetMasterVolume(float volume)
    {
        audioMixer.SetFloat(masterVolumeParam, fixSoundValue(volume));
    }

    public void SetMusicVolume(float volume)
    {
        audioMixer.SetFloat(musicVolumeParam, fixSoundValue(volume));
    }

    public void SetSFXVolume(float volume)
    {
        audioMixer.SetFloat(sfxVolumeParam, fixSoundValue(volume));
    }

    public void SetUIVolume(float volume)
    {
        audioMixer.SetFloat(uiVolumeParam, fixSoundValue(volume));
    }

    public void SetAmbientVolume(float volume)
    {
        audioMixer.SetFloat(ambientVolumeParam, fixSoundValue(volume)); // Set the ambient volume
    }

    // Method to set brightness (post-processing)
    public void SetBrightness(float value)
    {
        if (colorGrading != null)
        {
            colorGrading.brightness.value = Mathf.Clamp(value, brightnessSlider.minValue, brightnessSlider.maxValue);
        }
    }

    // Method to set mouse sensitivity
    public void SetSensitivity(float value)
    {
        if (playerController == null)
        {
            playerController = FindObjectOfType<GravityPlayerController>();
        }

        if (playerController != null)
        {
            // playerController.LookSensitivity = Mathf.Clamp(value, sensitivitySlider.minValue, sensitivitySlider.maxValue);
        }
    }

    // Method to set FOV
    public void SetFOV(float value)
    {
        if (playerCamera != null)
        {
            playerCamera.m_Lens.FieldOfView = Mathf.Clamp(value, fovSlider.minValue, fovSlider.maxValue);
        }
    }

    // Method to change resolution
    public void ChangeResolution(int resolutionIndex)
    {
        Resolution resolution = availableResolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreen);
    }

    // Method to toggle fullscreen
    public void SetFullScreen(bool isFullscreen)
    {
        Screen.fullScreen = isFullscreen;
    }

    // Method to save settings
    public void SaveSettings()
    {
        // Save graphics quality
        PlayerPrefs.SetInt("QualityLevel", QualitySettings.GetQualityLevel());

        // Save volumes
        float volume;

        audioMixer.GetFloat(masterVolumeParam, out volume);
        PlayerPrefs.SetFloat(masterVolumeParam, volume);

        audioMixer.GetFloat(musicVolumeParam, out volume);
        PlayerPrefs.SetFloat(musicVolumeParam, volume);

        audioMixer.GetFloat(sfxVolumeParam, out volume);
        PlayerPrefs.SetFloat(sfxVolumeParam, volume);

        audioMixer.GetFloat(uiVolumeParam, out volume);
        PlayerPrefs.SetFloat(uiVolumeParam, volume);

        audioMixer.GetFloat(ambientVolumeParam, out volume); // Save ambient volume
        PlayerPrefs.SetFloat(ambientVolumeParam, volume);

        // Save brightness
        PlayerPrefs.SetFloat("Brightness", brightnessSlider.value);

        // Save sensitivity
        PlayerPrefs.SetFloat("Sensitivity", sensitivitySlider.value);

        // Save FOV
        PlayerPrefs.SetFloat("FOV", fovSlider.value);

        // Save resolution settings
        PlayerPrefs.SetInt("Resolution", resolutionDropdown.value);

        // Save fullscreen setting
        PlayerPrefs.SetInt("Fullscreen", Screen.fullScreen ? 1 : 0);

        PlayerPrefs.Save();
    }

    // Method to load settings
    public void LoadSettings()
    {
        // Load and apply graphics quality
        int qualityLevel = PlayerPrefs.GetInt("QualityLevel", defaultQualityLevel);
        ChangeQuality(qualityLevel);
        qualityDropdown.value = qualityLevel;

        // Load and apply volumes
        float volume;

        volume = PlayerPrefs.GetFloat("MasterVolume", defaultVolume);
        SetMasterVolume(inverseFixSoundValue(volume));
        masterVolumeSlider.value = inverseFixSoundValue(volume);

        volume = PlayerPrefs.GetFloat("MusicVolume", defaultVolume);
        SetMusicVolume(inverseFixSoundValue(volume));
        musicVolumeSlider.value = inverseFixSoundValue(volume);

        volume = PlayerPrefs.GetFloat("SFXVolume", defaultVolume);
        SetSFXVolume(inverseFixSoundValue(volume));
        sfxVolumeSlider.value = inverseFixSoundValue(volume);

        volume = PlayerPrefs.GetFloat("UIVolume", defaultVolume);
        SetUIVolume(inverseFixSoundValue(volume));
        uiVolumeSlider.value = inverseFixSoundValue(volume);

        volume = PlayerPrefs.GetFloat("AmbientVolume", defaultVolume); // Load ambient volume
        SetAmbientVolume(inverseFixSoundValue(volume));
        ambientVolumeSlider.value = inverseFixSoundValue(volume);

        // Load and apply brightness
        float brightness = PlayerPrefs.GetFloat("Brightness", defaultBrightness);
        SetBrightness(brightness);
        brightnessSlider.value = brightness;

        // Load and apply sensitivity
        float sensitivity = PlayerPrefs.GetFloat("Sensitivity", defaultSensitivity);
        SetSensitivity(sensitivity);
        sensitivitySlider.value = sensitivity;

        // Load and apply FOV
        float fov = PlayerPrefs.GetFloat("FOV", defaultFOV);
        SetFOV(fov);
        fovSlider.value = fov;

        // Load and apply resolution settings
        int resolutionIndex = PlayerPrefs.GetInt("Resolution", 0);
        ChangeResolution(resolutionIndex);
        resolutionDropdown.value = resolutionIndex;

        // Load and apply fullscreen setting
        bool isFullscreen = PlayerPrefs.GetInt("Fullscreen", Screen.fullScreen ? 1 : 0) == 1;
        SetFullScreen(isFullscreen);
        fullscreenToggle.isOn = isFullscreen;
    }

    // Optional: Reset settings to default values
    public void ResetSettings()
    {
        // Reset to default quality level
        ChangeQuality(defaultQualityLevel);
        qualityDropdown.value = defaultQualityLevel;

        // Reset volumes to default (0dB)
        SetMasterVolume(defaultVolume);
        masterVolumeSlider.value = inverseFixSoundValue(defaultVolume);

        SetMusicVolume(defaultVolume);
        musicVolumeSlider.value = inverseFixSoundValue(defaultVolume);

        SetSFXVolume(defaultVolume);
        sfxVolumeSlider.value = inverseFixSoundValue(defaultVolume);

        SetUIVolume(defaultVolume);
        uiVolumeSlider.value = inverseFixSoundValue(defaultVolume);

        SetAmbientVolume(defaultVolume); // Reset ambient volume to default
        ambientVolumeSlider.value = inverseFixSoundValue(defaultVolume);

        // Reset brightness to default
        SetBrightness(defaultBrightness);
        brightnessSlider.value = defaultBrightness;

        // Reset sensitivity to default
        SetSensitivity(defaultSensitivity);
        sensitivitySlider.value = defaultSensitivity;

        // Reset FOV to default
        SetFOV(defaultFOV);
        fovSlider.value = defaultFOV;

        // Reset resolution to the default screen resolution
        resolutionDropdown.value = Array.FindIndex(availableResolutions, res => res.width == Screen.currentResolution.width && res.height == Screen.currentResolution.height);
        ChangeResolution(resolutionDropdown.value);

        // Reset fullscreen to the default value
        fullscreenToggle.isOn = true;
        SetFullScreen(true);

        // Save the reset settings
        SaveSettings();
    }

    private void SetMaxResolution()
    {
        // Set the resolution to the highest available resolution
        availableResolutions = Screen.resolutions;
        Resolution maxResolution = availableResolutions[availableResolutions.Length - 1];
        Screen.SetResolution(maxResolution.width, maxResolution.height, true);

        // Update UI elements
        resolutionDropdown.value = availableResolutions.Length - 1;
        fullscreenToggle.isOn = true;
        SetFullScreen(true);
    }

    public float fixSoundValue(float sliderValue)
    {
        // Verificar que el valor esté en el rango [0, 1]
        if (sliderValue < 0 || sliderValue > 1)
        {
            throw new ArgumentOutOfRangeException(nameof(sliderValue), "El valor del slider debe estar entre 0 y 1.");
        }

        // Puntos de control
        float[] sliderPositions = { 0f, 0.25f, 0.5f, 1f };
        float[] outputValues = { -80f, -20f, 0f, 20f };

        // Interpolación lineal
        if (sliderValue <= 0.25f)
        {
            // Interpolación entre -80 y -20
            return Mathf.Lerp(-80f, -20f, sliderValue / 0.25f);
        }
        else if (sliderValue <= 0.5f)
        {
            // Interpolación entre -20 y 0
            return Mathf.Lerp(-20f, 0f, (sliderValue - 0.25f) / 0.25f);
        }
        else
        {
            // Interpolación entre 0 y 20
            return Mathf.Lerp(0f, 20f, (sliderValue - 0.5f) / 0.5f);
        }
    }

    public float inverseFixSoundValue(float value)
    {
        // Verificar que el valor esté en el rango [-80, 20]
        if (value < -80f || value > 20f)
        {
            throw new ArgumentOutOfRangeException(nameof(value), "El valor debe estar entre -80 y 20.");
        }

        // Desinterpolar
        if (value <= -20f)
        {
            // Interpolación inversa entre -80 y -20
            return (value + 80f) / 60f * 0.25f; // Devuelve valor entre 0 y 0.25
        }
        else if (value <= 0f)
        {
            // Interpolación inversa entre -20 y 0
            return 0.25f + ((value + 20f) / 20f * 0.25f); // Devuelve valor entre 0.25 y 0.5
        }
        else
        {
            // Interpolación inversa entre 0 y 20
            return 0.5f + ((value / 20f) * 0.5f); // Devuelve valor entre 0.5 y 1
        }
    }


}
