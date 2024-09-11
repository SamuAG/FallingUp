using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestInteractive : MonoBehaviour, IInteractive
{
    public void Interact()
    {
        Debug.Log("Has interactuado con un objeto!");
    }
}
