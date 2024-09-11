using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class InitialSceneLoader : MonoBehaviour
{
    [SerializeField] private GameManagerSO gM;
    void Start()
    {
        gM.LoadGame();
    }
}
