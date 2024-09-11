using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseUI : MonoBehaviour
{
    [SerializeField] private GameManagerSO gameManager;
    [SerializeField] private GameObject hud;
    [SerializeField] private GameObject loadingScreen;
    [SerializeField] private GameObject pauseMenu;

    void Awake()
    {
        gameManager.Hud = hud;
        gameManager.LoadingScreen = loadingScreen;
        gameManager.PauseMenu = pauseMenu;
    }

}
