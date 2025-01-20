using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GravityObject : MonoBehaviour
{
    [SerializeField] private float gravityForce = 9.81f; // Fuerza de gravedad aumentada
    [SerializeField] private Vector3 gravityDirection = Vector3.down; // Gravedad personalizada (hacia abajo por defecto)
    [SerializeField] private Transform target; // Objetivo para cuando esté en esferas
    [SerializeField] private bool isRepulsor;

    private Rigidbody rb;

    public float GravityForce { get => gravityForce; set => gravityForce = value; }
    public Vector3 GravityDirection { get => gravityDirection; set => gravityDirection = value; }
    public Transform Target { get => target; set => target = value; }
    public bool IsRepulsor { get => isRepulsor; set => isRepulsor = value; }

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        if(rb == null)
        {
            Debug.LogError("Al objeto " + gameObject.name + " le falta un rigidBody!");
            return;
        }
        rb.useGravity = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (rb == null) return;

        if (target != null)
        {
            Vector3 targetDirection;
            if (!isRepulsor)
            {
                targetDirection = (target.position - transform.position).normalized;
            }
            else
            {
                targetDirection = (- target.position + transform.position).normalized;
            }
            gravityDirection = targetDirection;
        }
    }

    private void FixedUpdate()
    {
        // Aplicar la gravedad personalizada al Rigidbody
        rb.AddForce(gravityDirection * gravityForce, ForceMode.Acceleration);
    }
}