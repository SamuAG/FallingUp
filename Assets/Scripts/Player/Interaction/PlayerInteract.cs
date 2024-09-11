using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{
    [SerializeField] private Transform playerCamera;
    [SerializeField] private float range = 3f;
    [SerializeField] private LayerMask interactableLayer;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            RaycastHit hit;
            if (Physics.Raycast(playerCamera.position, playerCamera.forward, out hit, range, interactableLayer))
            {
                Debug.Log("Hit: " + hit.collider.gameObject.name);
                IInteractive target;
                if (hit.collider.gameObject.TryGetComponent<IInteractive>(out target))
                {
                    target.Interact();
                }
            }
        }
    }
}