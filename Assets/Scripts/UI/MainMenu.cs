using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{
    [SerializeField] private Button continueButton;
    [SerializeField] private string baseSceneName = "Base";
    [SerializeField] private GameObject optionsPanel;

    private void Start()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        optionsPanel.SetActive(false);

        continueButton.interactable = SaveSystem.SaveFileExists();
    }

    public void NewGame()
    {
        SaveSystem.ClearSavedData();
        Initiate.Fade(baseSceneName, UnityEngine.Color.black, 1.0f);
    }

    public void LoadGame()
    {
        Initiate.Fade(baseSceneName, UnityEngine.Color.black, 1.0f);
    }

    public void ToggleOptions()
    {
        optionsPanel.SetActive(!optionsPanel.activeSelf);
    }

    public void OpenLink(string link)
    {
        Application.OpenURL(link);
    }

    public void Quit()
    {
        Application.Quit();
    }
}
