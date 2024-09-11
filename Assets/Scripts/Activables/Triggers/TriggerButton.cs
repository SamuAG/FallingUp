using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerButton : ActivableTrigger
{
    // un booleano por si tiene un solo uso
    [SerializeField] private bool singleUse = false;
    private bool used = false;
    protected override void HandleActivationChanged(bool isActive)
    {
        Debug.Log("Botón cambiando estado");
    }

    protected override void OnTriggerActivated()
    {
        Debug.Log("Botón activado");
    }

    protected override void OnTriggerDeactivated()
    {
        Debug.Log("Botón desactivado");
    }

    private void OnTriggerEnter(Collider other)
    {
        // Verificar si el objeto está en una capa válida
        if (other.GetComponent<PlayerBasics>() && !used)
        {
            if(singleUse) used = true;
            OnTriggerActivated();
            ToggleAll();
        }
    }
}
