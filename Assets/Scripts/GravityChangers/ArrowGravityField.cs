using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrowGravityField : MonoBehaviour
{
    [SerializeField] private GravityField gravityField;
    [SerializeField] private float rotationSpeed = 5f;

    void Update()
    {
        if (gravityField == null)
        {
            Debug.LogWarning("gravityField no esta asignado en " + gameObject.name);
            return;
        }

        Vector3 gravityDirection = gravityField.GravityDirection;
        Transform target = gravityField.Target;

        if (target)
        {
            Quaternion targetRotation = Quaternion.FromToRotation(Vector3.down, target.position - transform.position);

            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, Time.deltaTime * rotationSpeed);
        }
        else if (gravityDirection != Vector3.zero)
        {
            // Calcula la rotacion para que la parte inferior del objeto (Vector3.down) apunte en la direccion de la gravedad
            Quaternion targetRotation = Quaternion.FromToRotation(Vector3.down, gravityDirection);

            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, Time.deltaTime * rotationSpeed);
        }
    }
}
