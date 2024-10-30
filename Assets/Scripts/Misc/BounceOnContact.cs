using UnityEngine;

public class BounceOnContact : MonoBehaviour
{
    public float bounceForce = 5f; // Fuerza del rebote
    public Vector3 bounceDirection = Vector3.up; // Direcci�n del rebote

    void OnCollisionEnter(Collision collision)
    {
        // Verifica que el objeto que colisiona tenga un Rigidbody y no sea cinem�tico
        Rigidbody rb = collision.rigidbody;
        if (rb != null && !rb.isKinematic)
        {

            // A�ade una peque�a correcci�n en la direcci�n del rebote para asegurarte de que no se anule por restricciones
            Vector3 adjustedBounceDirection = (bounceDirection + Vector3.up * 0.1f).normalized;

            // Aplica una fuerza en la direcci�n de la normal ajustada
            rb.velocity = Vector3.zero; // Reinicia la velocidad del Rigidbody para que el impulso sea efectivo
            rb.AddForce(adjustedBounceDirection * bounceForce, ForceMode.Impulse);
        }
    }
}
