using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectDisablerTrigger : MonoBehaviour
{
    [SerializeField] List<GameObject> objectsToDisable;
    [SerializeField] List<GameObject> objectsToEnable;
    private void Start()
    {
        foreach (GameObject obj in objectsToEnable)
        {
            obj.SetActive(false);
        }

        foreach (GameObject obj in objectsToDisable)
        {
            obj.SetActive(true);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        // Verificar si el objeto está en una capa válida
        if (other.GetComponent<PlayerBasics>())
        {
            foreach (GameObject obj in objectsToEnable)
            {
                obj.SetActive(true);
            }

            foreach (GameObject obj in objectsToDisable)
            {
                obj.SetActive(false);
            }
        }
    }
}
