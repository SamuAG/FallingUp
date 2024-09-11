using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorButton : ActivableTrigger
{
    [SerializeField] private Transform movingPart;
    [SerializeField] private float moveDistance = 0.1f; // Distancia que se mover� la parte m�vil
    [SerializeField] private float moveSpeed = 0.1f; // Velocidad del movimiento
    [SerializeField] private LayerMask activatableLayers;

    private Vector3 initialPosition; // Posici�n inicial de la parte m�vil
    private Vector3 pressedPosition; // Posici�n cuando el bot�n est� presionado

    private int objectsInTrigger = 0;

    override protected void Start()
    {
        if (movingPart != null)
        {
            initialPosition = movingPart.position;
            pressedPosition = initialPosition + new Vector3(0, -moveDistance, 0);
        }
        base.Start();
    }

    protected override void HandleActivationChanged(bool isActive)
    {
        if (movingPart != null)
        {
            StopAllCoroutines(); // Detener cualquier movimiento en curso
            if (isActive)
            {
                StartCoroutine(MoveToPosition(pressedPosition));
            }
            else
            {
                StartCoroutine(MoveToPosition(initialPosition));
            }
        }
    }

    private IEnumerator MoveToPosition(Vector3 targetPosition)
    {
        while (Vector3.Distance(movingPart.position, targetPosition) > 0.01f)
        {
            movingPart.position = Vector3.MoveTowards(movingPart.position, targetPosition, moveSpeed * Time.deltaTime);
            yield return null;
        }
        movingPart.position = targetPosition; // Asegurarse de que la posici�n final sea exacta
    }

    protected override void OnTriggerActivated()
    {
        Debug.Log("Bot�n activado");
    }

    protected override void OnTriggerDeactivated()
    {
        Debug.Log("Bot�n desactivado");
    }

    private void OnTriggerEnter(Collider other)
    {
        // Verificar si el objeto est� en una capa v�lida
        if (IsInLayerMask(other.gameObject, activatableLayers))
        {
            objectsInTrigger++;

            if (objectsInTrigger == 1) // Solo activar si es el primer objeto que entra
            {
                OnTriggerActivated();
                ActivateAll();
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        // Verificar si el objeto est� en una capa v�lida
        if (IsInLayerMask(other.gameObject, activatableLayers))
        {
            objectsInTrigger--;

            if (objectsInTrigger == 0) // Solo desactivar si no quedan objetos en el Trigger
            {
                OnTriggerDeactivated();
                DeactivateAll();
            }
        }
    }
    private bool IsInLayerMask(GameObject obj, LayerMask layerMask)
    {
        return ((layerMask.value & (1 << obj.layer)) > 0);
    }
}
