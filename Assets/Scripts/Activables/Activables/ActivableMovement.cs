using System;
using System.Collections;
using UnityEngine;

public class ActivableMovement : MonoBehaviour, IActivable
{
    [SerializeField] private float openHeight = 2.5f; // Altura a la que se abrir� la puerta
    [SerializeField] private float openSpeed = 2f; // Velocidad a la que se mover� la puerta
    [SerializeField] private float closeSpeed = 2f; // Velocidad a la que se cerrar� la puerta
    [SerializeField] private Vector3 direction = Vector3.zero;

    private Vector3 closedPosition; // Posici�n original de la puerta
    private Vector3 openPosition; // Posici�n cuando la puerta est� abierta
    private bool isActive = false; // Estado actual de la puerta

    public bool IsActive => isActive;

    public event Action<bool> OnActivationChanged;

    private void Start()
    {
        // Guardar la posici�n original y calcular la posici�n abierta
        closedPosition = transform.position;
        openPosition = closedPosition + direction * openHeight;
    }

    public void Activate()
    {
        if (!isActive)
        {
            isActive = true;
            OnActivationChanged?.Invoke(isActive);
            StopAllCoroutines();
            StartCoroutine(MoveDoor(openPosition, openSpeed));
        }
    }

    public void Deactivate()
    {
        if (isActive)
        {
            isActive = false;
            OnActivationChanged?.Invoke(isActive);
            StopAllCoroutines();
            StartCoroutine(MoveDoor(closedPosition, closeSpeed));
        }
    }

    public void Toggle()
    {
        if (isActive)
        {
            Deactivate();
        }
        else
        {
            Activate();
        }
    }

    public void ActivateForDuration(float duration)
    {
        Activate();
        StartCoroutine(DeactivateAfterDuration(duration));
    }

    private IEnumerator DeactivateAfterDuration(float duration)
    {
        yield return new WaitForSeconds(duration);
        Deactivate();
    }

    private IEnumerator MoveDoor(Vector3 targetPosition, float speed)
    {
        while (Vector3.Distance(transform.position, targetPosition) > 0.01f)
        {
            transform.position = Vector3.MoveTowards(transform.position, targetPosition, speed * Time.deltaTime);
            yield return null;
        }
        transform.position = targetPosition; // Asegurarse de que la puerta termine en la posici�n exacta
    }
}
