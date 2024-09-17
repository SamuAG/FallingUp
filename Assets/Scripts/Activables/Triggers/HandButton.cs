using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandButton : ActivableTrigger, IInteractive
{
    [SerializeField] private Transform movingPart;
    [SerializeField] private float moveDistance = 0.01f; // Distancia que se mover� la parte m�vil
    [SerializeField] private float moveSpeed = 0.1f; // Velocidad del movimiento
    [SerializeField] private AudioSource audioSource;

    private Vector3 initialPosition; // Posici�n inicial de la parte m�vil
    private Vector3 pressedPosition; // Posici�n cuando el bot�n est� presionado

    override protected void Start()
    {
        if (movingPart != null)
        {
            initialPosition = movingPart.position;
            // Calculamos la direcci�n local hacia abajo con TransformDirection
            pressedPosition = initialPosition + movingPart.TransformDirection(Vector3.forward) * moveDistance;
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

    public void Interact()
    {
        Debug.Log("Bot�n presionado");
        if(audioSource) audioSource.Play();
        ToggleAll();
    }
}
