using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GravityPlayerController : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f; // Velocidad de movimiento del jugador
    [SerializeField] private float sprintSpeed = 8f; // Velocidad de movimiento cuando sprinta
    [SerializeField] private float crouchSpeed = 3.0f;          // Velocidad al agacharse
    [SerializeField] private float maxSpeed = 10f; // Velocidad máxima permitida
    [SerializeField] private float lookSensitivity = 2f; // Sensibilidad de la cámara al mirar alrededor
    private CapsuleCollider collider;
    private bool isCrouching = false;
    private float originalHeight;             
    [SerializeField] private float crouchHeight = 1.0f;
    [SerializeField] private LayerMask ceilingLayer;
    [SerializeField] private float jumpForce = 5f; // Fuerza de salto
    [SerializeField] private LayerMask groundLayer; // Capa del suelo para detección

    private Rigidbody rb;
    private Transform cameraTransform;
    private bool isGrounded;
    private float pitch = 0f;

    [SerializeField] private Transform groundCheck; // Posición desde la cual se hace la verificación del suelo
    [SerializeField] private float groundDistance = 0.3f; // Distancia del radio para la verificación del suelo

    [SerializeField] private float gravityForce = -9.81f; // Fuerza de gravedad aumentada
    [SerializeField] private Vector3 gravityDirection = Vector3.down; // Gravedad personalizada (hacia abajo por defecto)
    [SerializeField] private Transform target; // Objetivo para cuando esté en esferas
    [SerializeField] private bool isTargetRepulsor = false; // Si el objetivo es un repulsor

    public float GravityForce { get => gravityForce; set => gravityForce = value; }
    public Vector3 GravityDirection { get => gravityDirection; set => gravityDirection = value; }
    public Transform Target { get => target; set => target = value; }
    public bool IsTargetRepulsor { get => isTargetRepulsor; set => isTargetRepulsor = value; }
    public float LookSensitivity { get => lookSensitivity; set => lookSensitivity = value; }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        cameraTransform = Camera.main.transform;

        collider = GetComponent<CapsuleCollider>();
        originalHeight = collider.height;

        // Deshabilitar la gravedad predeterminada de Unity
        rb.useGravity = false;
    }

    private void Update()
    {
        // Obtener la entrada del mouse para la rotación de la cámara
        float mouseX = Input.GetAxis("Mouse X") * lookSensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * lookSensitivity;

        // Rotar la cámara alrededor del eje X e Y
        transform.Rotate(0, mouseX, 0);
        cameraTransform.Rotate(-mouseY, 0, 0);

        // Ajustar el pitch de la cámara y aplicar el clamping
        pitch -= mouseY; // Invertir para que hacia arriba aumente el ángulo
        pitch = Mathf.Clamp(pitch, -90f, 90f); // Clampa el pitch para evitar flip de la cámara
        cameraTransform.localEulerAngles = new Vector3(pitch, 0, 0);

        // Detectar si el jugador está en el suelo
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundLayer);

        // Movimiento del jugador basado en la entrada del teclado
        float moveHorizontal = Input.GetAxis("Horizontal");
        float moveVertical = Input.GetAxis("Vertical");

        // Determinar si el jugador está sprintando
        bool isSprinting = Input.GetKey(KeyCode.LeftShift);

        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            Crouch();
        }
        else if (!Input.GetKey(KeyCode.LeftControl))
        {
            TryStandUp();
        }

        float currentSpeed = isCrouching ? crouchSpeed : ((isSprinting) ? sprintSpeed : moveSpeed);

        // Crear una dirección de movimiento en el espacio local
        Vector3 moveDirection = new Vector3(moveHorizontal, 0, moveVertical);
        moveDirection = transform.TransformDirection(moveDirection) * currentSpeed;
        moveDirection = Vector3.ProjectOnPlane(moveDirection, gravityDirection).normalized * currentSpeed;

        // Actualizar la dirección de la gravedad
        if (target != null)
        {
            Vector3 targetDirection = isTargetRepulsor ? ((transform.position - target.position).normalized) : ((target.position - transform.position).normalized);
            gravityDirection = targetDirection;
        }

        // Rotar hacia la dirección de la gravedad
        RotateTowards(-gravityDirection);

        // Aplicar la dirección de movimiento al Rigidbody
        Vector3 horizontalVelocity = moveDirection;
        Vector3 verticalVelocity = Vector3.Project(rb.velocity, gravityDirection);

        // Combina las velocidades y luego limita la velocidad total
        rb.velocity = horizontalVelocity + verticalVelocity;
        rb.velocity = Vector3.ClampMagnitude(rb.velocity, maxSpeed);

        // Saltar si el jugador está en el suelo y presiona el botón de salto
        if (isGrounded && Input.GetButtonDown("Jump"))
        {
            Jump();
        }
    }

    private void FixedUpdate()
    {
        // Aplicar la gravedad personalizada al Rigidbody
        rb.AddForce(gravityDirection * gravityForce, ForceMode.Acceleration);
    }

    // Método para rotar hacia una dirección específica, con Y apuntando hacia la gravedad
    private void RotateTowards(Vector3 direction)
    {
        // Calcular la rotación deseada
        Quaternion targetRotation = Quaternion.FromToRotation(transform.up, direction) * transform.rotation;

        // Aplicar la rotación suave hacia la dirección deseada
        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * moveSpeed);
    }

    // Método para realizar el salto
    private void Jump()
    {
        // Aplicar una fuerza de salto en la dirección opuesta a la gravedad
        if(!isCrouching) rb.AddForce(-gravityDirection * jumpForce, ForceMode.Impulse);
    }

    void Crouch()
    {
        isCrouching = true;
        collider.height = crouchHeight;
        cameraTransform.localPosition = new Vector3(0, crouchHeight / 2f - 0.25f, 0);
        //controller.center = new Vector3(0, crouchHeight / 2f, 0);
    }

    void TryStandUp()
    {
        // Comprobar si hay espacio para ponerse de pie
        RaycastHit hit;
        if (!Physics.SphereCast(transform.position, collider.radius, transform.up, out hit, originalHeight - crouchHeight, ceilingLayer))
        {
            // Si no hay nada encima, levantarse
            StandUp();
        }
    }

    void StandUp()
    {
        isCrouching = false;
        collider.height = originalHeight;
        cameraTransform.localPosition = new Vector3(0, originalHeight / 2f - 0.5f, 0);
        //controller.center = new Vector3(0, originalHeight / 2f, 0);
    }
}
