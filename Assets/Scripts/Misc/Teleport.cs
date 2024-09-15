using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Teleport : MonoBehaviour
{
    [SerializeField] private Vector3 destination = Vector3.zero;
    [SerializeField] private Vector3 gravityDirection = Vector3.down;
    [SerializeField] private Transform target = null;
    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<PlayerBasics>()) // Asegúrate de que solo el jugador active el cambio de nivel
        {
            other.transform.position = destination;
            if (target != null)
            {
                other.GetComponent<GravityPlayerController>().Target = target;
            }
            else
            {
                other.GetComponent<GravityPlayerController>().GravityDirection = gravityDirection;
            }
        }
    }
}
