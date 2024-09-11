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
        Debug.Log("Bot�n cambiando estado");
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
        if (other.GetComponent<PlayerBasics>() && !used)
        {
            if(singleUse) used = true;
            OnTriggerActivated();
            ToggleAll();
        }
    }
}
