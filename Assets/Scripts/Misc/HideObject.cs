using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideObject : MonoBehaviour
{
    [SerializeField] private bool IsDebug = false;
    void Start()
    {
        if (!IsDebug)
        {
            GetComponent<Renderer>().enabled = false;
        }
    }
}
