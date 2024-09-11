using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class LoadBright : MonoBehaviour
{
    void Start()
    {
        ColorGrading colorGrading;
        if (GetComponent<PostProcessVolume>().profile.TryGetSettings(out colorGrading))
        {
            colorGrading.brightness.value = PlayerPrefs.GetFloat("Brightness", 0);
        }
    }
}
