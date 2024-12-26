using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectGravityDirection : MonoBehaviour
{
    [SerializeField] private GravityObject gravityObject;
    [SerializeField] private float rotationSpeed = 5f;

    void Update()
    {
        if (gravityObject == null)
        {
            Debug.LogWarning("GravityObject no esta asignado en " + gameObject.name);
            return;
        }

        Vector3 gravityDirection = gravityObject.GravityDirection;

        if (gravityDirection != Vector3.zero)
        {
            // Calcula la rotacion para que la parte inferior del objeto (Vector3.down) apunte en la direccion de la gravedad
            Quaternion targetRotation = Quaternion.FromToRotation(Vector3.down, gravityDirection);

            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, Time.deltaTime * rotationSpeed);
        }
    }
}
