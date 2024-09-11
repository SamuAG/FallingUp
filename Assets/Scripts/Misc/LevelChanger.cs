using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelChanger : MonoBehaviour
{
    [SerializeField] private GameManagerSO gameManager;
    [SerializeField] private List<int> scenesToUnload = new List<int>();
    [SerializeField] private List<int> scenesToLoad = new List<int>();
    [SerializeField] private bool hasGravityGun = true;
    [SerializeField] private Transform checkpoint;
    [SerializeField] private int levelNumber = 2;
    [SerializeField] private int lastLevelFinished = 0;

    private bool isChangingScenes = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<PlayerBasics>()) // Asegúrate de que solo el jugador active el cambio de nivel
        {
            gameManager.SaveGame(hasGravityGun, checkpoint.position, checkpoint.rotation.eulerAngles, levelNumber, lastLevelFinished);
            StartCoroutine(ChangeScenes());
        }
    }

    private IEnumerator ChangeScenes()
    {
        if (isChangingScenes)
        {
            yield break;
        }

        isChangingScenes = true;

        // Activar la pantalla de carga
        if (gameManager.LoadingScreen.GetComponent<Canvas>() != null)
        {
            gameManager.LoadingScreen.GetComponent<Canvas>().enabled = true;
        }

        // Pausar el tiempo del juego
        Time.timeScale = 0f;

        // Primero, cargar las escenas nuevas
        foreach (int sceneIndex in scenesToLoad)
        {
            yield return SceneManager.LoadSceneAsync(sceneIndex, LoadSceneMode.Additive);
        }

        // Reanudar el tiempo del juego
        Time.timeScale = 1f;

        // Desactivar la pantalla de carga
        if (gameManager.LoadingScreen.GetComponent<Canvas>() != null)
        {
            gameManager.LoadingScreen.GetComponent<Canvas>().enabled = false;
        }

        // Luego, descargar las escenas antiguas
        foreach (int sceneIndex in scenesToUnload)
        {
            yield return SceneManager.UnloadSceneAsync(sceneIndex);
        }

        isChangingScenes = false;
    }
}
