using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClockGravityModifier : GravityObjectModifier
{
    [SerializeField] private float changeInterval = 5f; // Tiempo en segundos entre cada cambio de direcci�n
    private float timeElapsed;
    Rigidbody rb;

    private void Update()
    {
        // Incrementar el tiempo transcurrido
        timeElapsed += Time.deltaTime;

        // Comprobar si ha pasado el tiempo suficiente para cambiar la direcci�n
        if (timeElapsed >= changeInterval)
        {
            // Cambiar la direcci�n de la gravedad a la direcci�n contraria
            gravityObject.GravityDirection = -gravityObject.GravityDirection;

            // Reiniciar el temporizador
            timeElapsed = 0f;

            // Resetear la inercia en el Rigidbody
            ResetInertia();
        }
    }

    private void ResetInertia()
    {
        // Obtener el Rigidbody del GravityObject
        if(!rb) rb = gravityObject.GetComponent<Rigidbody>();
        if (rb != null)
        {
            // Restablecer la velocidad del Rigidbody, manteniendo solo la componente a lo largo de la direcci�n de la gravedad
            rb.velocity = Vector3.zero;
        }
    }

    public override void ModifyGravityPrimary()
    {
        return;
    }

    public override void ModifyGravitySecondary()
    {
        return;
    }
}
