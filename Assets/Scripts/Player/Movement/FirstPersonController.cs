using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class FirstPersonController : MonoBehaviour
{
    public float speed = 6.0f;                // Velocidad de movimiento
    public float runSpeed = 12.0f;            // Velocidad al correr
    public float crouchSpeed = 3.0f;          // Velocidad al agacharse
    public float mouseSensitivity = 100.0f;   // Sensibilidad del mouse
    public float gravity = -9.81f;            // Gravedad aplicada al jugador
    public float jumpHeight = 1.5f;           // Altura del salto
    public Transform groundCheck;             // Transform del GroundCheck
    public float groundDistance = 0.4f;       // Distancia de detecci�n del suelo
    public LayerMask groundMask;              // M�scara de capas para el suelo
    public LayerMask ceilingMask;             // M�scara de capas para el techo (obst�culos)

    private CharacterController controller;   // Referencia al CharacterController
    private Transform playerCamera;           // Referencia a la c�mara
    private Vector3 velocity;                 // Velocidad de ca�da
    private float xRotation = 0.0f;           // Rotaci�n en el eje X (mirar arriba/abajo)
    private bool isGrounded;                  // Indica si el jugador est� en el suelo
    private bool isCrouching = false;         // Indica si el jugador est� agachado

    private float originalHeight;             // Altura original del CharacterController
    public float crouchHeight = 1.0f;         // Altura del CharacterController cuando est� agachado

    void Start()
    {
        controller = GetComponent<CharacterController>();
        playerCamera = Camera.main.transform; // Asumimos que la c�mara es la principal

        // Guardar la altura original del CharacterController
        originalHeight = controller.height;

        // Bloquear el cursor al centro de la pantalla y ocultarlo
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
    {
        // Comprobar si el jugador est� en el suelo
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);

        // Resetear la velocidad vertical si el jugador est� en el suelo
        if (isGrounded && velocity.y < 0)
        {
            velocity.y = -2f; // Asegura que el jugador est� pegado al suelo
        }

        // Movimiento del mouse para rotaci�n de la c�mara
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, -90f, 90f); // Limitar rotaci�n vertical para evitar volteretas

        playerCamera.localRotation = Quaternion.Euler(xRotation, 0f, 0f);
        transform.Rotate(Vector3.up * mouseX);

        // Determinar si el jugador est� agachado
        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            Crouch();
        }
        else if (!Input.GetKey(KeyCode.LeftControl))
        {
            TryStandUp();
        }

        // Determinar la velocidad seg�n si el jugador est� corriendo, caminando o agachado
        float currentSpeed = isCrouching ? crouchSpeed : (Input.GetKey(KeyCode.LeftShift) ? runSpeed : speed);

        // Movimiento del personaje
        float moveX = Input.GetAxis("Horizontal");
        float moveZ = Input.GetAxis("Vertical");

        Vector3 move = transform.right * moveX + transform.forward * moveZ;
        controller.Move(move * currentSpeed * Time.deltaTime);

        // Saltar
        if (Input.GetButtonDown("Jump") && isGrounded && !isCrouching)
        {
            velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
        }

        // Aplicar gravedad
        //if (!isGrounded)
        //{
            velocity.y += gravity * Time.deltaTime;
        //}
        
        controller.Move(velocity * Time.deltaTime);
    }

    void Crouch()
    {
        isCrouching = true;
        controller.height = crouchHeight;
        playerCamera.localPosition = new Vector3(0, crouchHeight / 2f - 0.25f, 0);
        //controller.center = new Vector3(0, crouchHeight / 2f, 0);
    }

    void TryStandUp()
    {
        // Comprobar si hay espacio para ponerse de pie
        RaycastHit hit;
        if (!Physics.SphereCast(transform.position, controller.radius, Vector3.up, out hit, originalHeight - crouchHeight, ceilingMask))
        {
            // Si no hay nada encima, levantarse
            StandUp();
        }
    }

    void StandUp()
    {
        isCrouching = false;
        controller.height = originalHeight;
        playerCamera.localPosition = new Vector3(0, originalHeight / 2f - 0.5f, 0);
        //controller.center = new Vector3(0, originalHeight / 2f, 0);
    }
}
