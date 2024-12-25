using QFSW.QC;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerBasics : MonoBehaviour
{
    [SerializeField] private GameManagerSO gameManager;
    [SerializeField] private GameObject gravityGun;
    [SerializeField] private Camera mainCam;
    [SerializeField] private Camera equipementCam;

    private void Awake()
    {
        gameManager.Player = gameObject;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void Start()
    {
        LoadPlayerPrefs();
    }

    [Command("giveGravityGun")]
    public void GivePlayerGravityGun()
    {
        GameObject spawnedGun = Instantiate(gravityGun, transform.position, transform.rotation, transform);
        spawnedGun.transform.parent = null;
        GetComponent<PickupAndEquip>().EquipObject(spawnedGun);
    }

    private void LoadPlayerPrefs()
    {
        float sensitivity = PlayerPrefs.GetFloat("Sensitivity", 2);
        GetComponent<GravityPlayerController>().LookSensitivity = sensitivity;
        float fov = PlayerPrefs.GetFloat("FOV", 60);
        mainCam.fieldOfView = fov;
        //equipementCam.fieldOfView = fov;
    }
}
