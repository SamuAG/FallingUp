using UnityEngine;
using System;
using UnityEngine.SceneManagement;

public class DestroyHandler : MonoBehaviour
{
    public event Action OnDestroyed; // Evento que se dispara antes de que el objeto se destruya
    private bool isSceneUnloading = false;

    private void Start()
    {
        SceneManager.sceneUnloaded += OnSceneUnloaded;
    }

    private void OnDestroy()
    {
        if (isSceneUnloading) return;
        // Ejecutar cualquier lógica necesaria antes de que el objeto sea destruido
        OnDestroyed?.Invoke();
    }

    private void OnSceneUnloaded(Scene current)
    {
        isSceneUnloading = true;
    }

    void OnApplicationQuit()
    {
        isSceneUnloading = true;
    }
}
