using UnityEngine;

public class BounceOnContact : MonoBehaviour
{
    public float bounceForce = 5f; // Fuerza del rebote
    public Vector3 bounceDirection = Vector3.up; // Dirección del rebote

    void OnCollisionEnter(Collision collision)
    {
        // Verifica que el objeto que colisiona tenga un Rigidbody y no sea cinemático
        Rigidbody rb = collision.rigidbody;
        if (rb != null && !rb.isKinematic)
        {

            // Añade una pequeña corrección en la dirección del rebote para asegurarte de que no se anule por restricciones
            Vector3 adjustedBounceDirection = (bounceDirection + Vector3.up * 0.1f).normalized;

            // Aplica una fuerza en la dirección de la normal ajustada
            rb.velocity = Vector3.zero; // Reinicia la velocidad del Rigidbody para que el impulso sea efectivo
            rb.AddForce(adjustedBounceDirection * bounceForce, ForceMode.Impulse);
        }
    }
}
