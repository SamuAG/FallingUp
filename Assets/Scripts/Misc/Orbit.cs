using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbit : MonoBehaviour
{
    public Transform sun; // El objeto central alrededor del cual el planeta orbita
    public float orbitSpeed = 10f; // Velocidad de la �rbita
    private float orbitRadius; // Distancia calculada al Sol

    [SerializeField] private Vector3 orbitAxis = Vector3.up; // Eje de rotaci�n (hacia adelante en 2D o hacia arriba en 3D)

    void Start()
    {
        // Calcular el radio de la �rbita restando las posiciones del planeta y el Sol
        orbitRadius = Vector3.Distance(transform.position, sun.position);
    }

    void Update()
    {
        // Orbitando alrededor del Sol
        transform.RotateAround(sun.position, orbitAxis, orbitSpeed * Time.deltaTime);

        // Mantener la distancia constante al Sol (radio de la �rbita)
        Vector3 desiredPosition = (transform.position - sun.position).normalized * orbitRadius + sun.position;
        transform.position = desiredPosition;
    }
}
