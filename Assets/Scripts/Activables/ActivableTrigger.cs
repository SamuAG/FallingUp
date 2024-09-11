using System;
using System.Collections.Generic;
using UnityEngine;

public abstract class ActivableTrigger : MonoBehaviour
{
    [SerializeField] private List<GameObject> activableObjects;
    protected List<IActivable> activables = new List<IActivable>();

    protected virtual void Start()
    {
        // Suscribirse al evento OnActivationChanged para todos los activables
        foreach (var activableObject in activableObjects)
        {
            var activable = activableObject.GetComponent<IActivable>();
            if (activable == null)
            {
                Debug.LogError("El objeto " + activableObject.name + " no tiene un componente IActivable");
                continue;
            }
            else
            {
                activables.Add(activable);
                activable.OnActivationChanged += HandleActivationChanged;
            }
        }
    }

    protected virtual void OnDestroy()
    {
        // Desuscribirse del evento OnActivationChanged para evitar fugas de memoria
        foreach (var activable in activables)
        {
            activable.OnActivationChanged -= HandleActivationChanged;
        }
    }

    protected void ActivateAll()
    {
        foreach (var activable in activables)
        {
            if (!activable.IsActive)
            {
                activable.Activate();
            }
        }
    }

    protected void DeactivateAll()
    {
        foreach (var activable in activables)
        {
            if (activable.IsActive)
            {
                activable.Deactivate();
            }
        }
    }

    protected void ActivateAllForDuration(float duration)
    {
        foreach (var activable in activables)
        {
            activable.ActivateForDuration(duration);
        }
    }

    protected void ToggleAll()
    {
        foreach (var activable in activables)
        {
            activable.Toggle();
        }
    }

    protected abstract void OnTriggerActivated();

    protected abstract void OnTriggerDeactivated();

    protected abstract void HandleActivationChanged(bool isActive);
}
