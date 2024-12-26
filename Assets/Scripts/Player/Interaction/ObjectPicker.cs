using UnityEngine;

public class ObjectPicker : MonoBehaviour
{
    public Transform playerCamera;               // Referencia a la cámara del jugador
    public float pickUpRange = 3.0f;             // Distancia máxima para recoger objetos
    public float holdDistance = 2.0f;            // Distancia a la que se sostendrá el objeto frente al jugador
    public float throwForce = 10.0f;             // Fuerza con la que se lanzará el objeto
    public float dropDistance = 2.0f;            // Distancia a la que se soltará el objeto si se aleja demasiado
    public float pickUpSpeed = 20.0f;            // Velocidad a la que se moverá el objeto hacia el jugador
    public LayerMask pickUpLayer;                // Máscara de capas para objetos levantables

    private GameObject heldObject = null;        // Objeto actualmente levantado
    private Rigidbody heldObjectRb;              // Rigidbody del objeto levantado

    public GameObject HeldObject { get => heldObject; set => heldObject = value; }

    void Update()
    {
        if (heldObject == null)
        {
            // Intentar recoger un objeto
            if (Input.GetKeyDown(KeyCode.E))
            {
                TryPickUpObject();
            }
        }
        else
        {
            // Mover el objeto levantado
            MoveObject();

            // Soltar el objeto
            if (Input.GetKeyDown(KeyCode.E))
            {
                DropObject();
            }

            // Lanzar el objeto
            if (Input.GetKeyDown(KeyCode.Q)) // Botón derecho del mouse
            {
                ThrowObject();
            }
        }
    }

    void TryPickUpObject()
    {
        Ray ray = new Ray(playerCamera.position, playerCamera.forward);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, pickUpRange, pickUpLayer))
        {
            // Intentar recoger el objeto si tiene un Rigidbody
            if (hit.collider.gameObject.GetComponent<Rigidbody>())
            {
                heldObject = hit.collider.gameObject;
                heldObjectRb = heldObject.GetComponent<Rigidbody>();

                // Desactivar la gravedad y fijar el objeto en su lugar
                GravityObject gravityObject;
                if (heldObjectRb.TryGetComponent<GravityObject>(out gravityObject)) gravityObject.enabled = false;
                else heldObjectRb.useGravity = false;

                heldObjectRb.freezeRotation = true;

                // Solucionar el propsurfing
                int playerLayer = LayerMask.NameToLayer("Player");
                heldObjectRb.excludeLayers |= (1 << playerLayer);
            }
        }
    }

    void MoveObject()
    {
        // Calcular la nueva posición y mover el objeto hacia ella
        //Vector3 targetPosition = playerCamera.position + playerCamera.forward * holdDistance;
        //Vector3 direction = targetPosition - heldObject.transform.position;

        //heldObjectRb.velocity = direction * 10f; // Ajusta el valor para suavizar el movimiento

        // Calcular la nueva posición a la que debe ir el objeto
        Vector3 targetPosition = playerCamera.position + playerCamera.forward * holdDistance;
        Vector3 direction = targetPosition - heldObject.transform.position;
        float distanceToTarget = direction.magnitude;

        // Si la distancia es mayor que un umbral (por ejemplo, 1.5 veces la distancia de retención), soltar el objeto
        if (distanceToTarget > holdDistance * dropDistance)
        {
            //heldObject.transform.position = targetPosition;
            DropObject();
        }
        else
        {
            // Si está dentro de un rango aceptable, moverlo gradualmente hacia la posición con MovePosition
            heldObjectRb.velocity = direction * pickUpSpeed;
        }
    }

    public void DropObject()
    {
        if(heldObject == null && heldObjectRb == null) return;

        // Que pueda volver a colisionar con el jugador
        int playerLayer = LayerMask.NameToLayer("Player");
        heldObjectRb.excludeLayers &= ~(1 << playerLayer);

        // Soltar el objeto
        GravityObject gravityObject;
        if (heldObjectRb.TryGetComponent<GravityObject>(out gravityObject)) gravityObject.enabled = true;
        else heldObjectRb.useGravity = true;
        heldObjectRb.freezeRotation = false;
        heldObject = null;
        heldObjectRb = null;
    }

    void ThrowObject()
    {
        // Que pueda volver a colisionar con el jugador
        int playerLayer = LayerMask.NameToLayer("Player");
        heldObjectRb.excludeLayers &= ~(1 << playerLayer);

        // Lanzar el objeto con una fuerza determinada
        GravityObject gravityObject;
        if (heldObjectRb.TryGetComponent<GravityObject>(out gravityObject)) gravityObject.enabled = true;
        else heldObjectRb.useGravity = true;
        heldObjectRb.freezeRotation = false;
        heldObjectRb.AddForce(playerCamera.forward * throwForce, ForceMode.VelocityChange);

        heldObject = null;
        heldObjectRb = null;
    }
}
