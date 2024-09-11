using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenu : MonoBehaviour
{
    [SerializeField] private GameManagerSO gM;
    private Canvas canvas;
    private bool isPaused = false;
    private bool canPause = true;
    // Start is called before the first frame update
    void Start()
    {
        canvas = GetComponent<Canvas>();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape) && canPause)
        {
            if (isPaused)
            {
                Resume();
            }
            else
            {
                Pause();
            }
        }
    }

    public void Resume()
    {
        isPaused = false;
        Time.timeScale = 1;
        gM.Player.GetComponent<GravityPlayerController>().enabled = true;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        canvas.enabled = false;
    }

    public void Pause()
    {
        isPaused = true;
        Time.timeScale = 0;
        gM.Player.GetComponent<GravityPlayerController>().enabled = false;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        canvas.enabled = true;
    }

    public void Restart()
    {
        Resume();
        gM.Player.GetComponent<PlayerLife>().Die();
        canPause = false;
    }

    public void GoToHub()
    {
        // Se podria modificar la informacion de la partida
        gM.SaveGame(gM.Player.GetComponent<PickupAndEquip>().CurrentObjectInHand != null, new Vector3(0,0,0), new Vector3(0, 0, 0), 1, -1);
        // y luego llamar a restart
        Restart();
    }

    public void MainMenu()
    {
        Resume();
        Initiate.Fade("MainMenu", UnityEngine.Color.black, 1.0f);
        canPause = false;
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
