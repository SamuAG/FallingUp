using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

[CreateAssetMenu(fileName = "GameManagerSO", menuName = "ScriptableObjects/GameManagerSO", order = 1)]  

public class GameManagerSO : ScriptableObject
{
    private GameObject player;
    private int lastLevelFinished;

    [NonSerialized] private GameObject hud;
    [NonSerialized] private GameObject loadingScreen;
    [NonSerialized] private GameObject pauseMenu;

    public GameObject Player { get => player; set => player = value; }
    public GameObject Hud { get => hud; set => hud = value; }
    public GameObject LoadingScreen { get => loadingScreen; set => loadingScreen = value; }
    public GameObject PauseMenu { get => pauseMenu; set => pauseMenu = value; }
    
    public void SaveGame(bool hasGravityGun, int currentLevel, int lastLevel)
    {
        GameData data = new GameData
        {
            hasGravityGun = hasGravityGun,
            spawnPositionX = player.transform.position.x,
            spawnPositionY = player.transform.position.y,
            spawnPositionZ = player.transform.position.z,
            spawnRotationX = player.transform.rotation.eulerAngles.x,
            spawnRotationY = player.transform.rotation.eulerAngles.y,
            spawnRotationZ = player.transform.rotation.eulerAngles.z,
            gravityForce = player.GetComponent<GravityPlayerController>().GravityForce,
            gravityDirectionX = player.GetComponent<GravityPlayerController>().GravityDirection.x,
            gravityDirectionY = player.GetComponent<GravityPlayerController>().GravityDirection.y,
            gravityDirectionZ = player.GetComponent<GravityPlayerController>().GravityDirection.z,
            levelNumber = currentLevel,
            lastLevelFinished = lastLevelFinished > lastLevel ? lastLevelFinished : lastLevel
        };

        SaveSystem.SaveGameData(data);
    }

    public void SaveGame(bool hasGravityGun, Vector3 playerPosition, Vector3 playerRotation, int currentLevel, int lastLevel)
    {
        GameData data = new GameData
        {
            hasGravityGun = hasGravityGun,
            spawnPositionX = playerPosition.x,
            spawnPositionY = playerPosition.y,
            spawnPositionZ = playerPosition.z,
            spawnRotationX = playerRotation.x,
            spawnRotationY = playerRotation.y,
            spawnRotationZ = playerRotation.z,
            gravityForce = player.GetComponent<GravityPlayerController>().GravityForce,
            gravityDirectionX = player.GetComponent<GravityPlayerController>().GravityDirection.x,
            gravityDirectionY = player.GetComponent<GravityPlayerController>().GravityDirection.y,
            gravityDirectionZ = player.GetComponent<GravityPlayerController>().GravityDirection.z,
            levelNumber = currentLevel,
            lastLevelFinished = lastLevelFinished > lastLevel ? lastLevelFinished : lastLevel
        };

        SaveSystem.SaveGameData(data);
    }

    public void LoadGame()
    {
        GameData data = SaveSystem.LoadGameData();

        int currentLevel = data.levelNumber;

        // Opcional: cargar la escena del nivel correspondiente si no estás ya en ella
        if (SceneManager.GetActiveScene().buildIndex != currentLevel)
        {
            SceneManager.LoadScene(currentLevel, LoadSceneMode.Additive);
            player.transform.position = new Vector3(data.spawnPositionX, data.spawnPositionY, data.spawnPositionZ);
            player.transform.rotation = Quaternion.Euler(data.spawnRotationX, data.spawnRotationY, data.spawnRotationZ);
            player.GetComponent<GravityPlayerController>().GravityForce = data.gravityForce;
            player.GetComponent<GravityPlayerController>().GravityDirection = new Vector3(data.gravityDirectionX, data.gravityDirectionY, data.gravityDirectionZ);
            if (data.hasGravityGun) player.GetComponent<PlayerBasics>().GivePlayerGravityGun();
            lastLevelFinished = data.lastLevelFinished;
        }
    }
}
