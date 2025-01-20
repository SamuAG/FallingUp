using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CrossAirHelper : MonoBehaviour
{
    [SerializeField] private Image crossAir;
    [SerializeField] private Transform playerCam;
    [SerializeField] private Color defaultColor = Color.white; // Color predeterminado
    [SerializeField] private Color gravitableColor = Color.green; // Color cuando es gravitable
    [SerializeField] private Color objectColor = Color.red; // Color cuando es gravitable
    [SerializeField] private LayerMask obstacleLayer;
    [SerializeField] private LayerMask targeteableLayer;
    [SerializeField] private LayerMask objectLayer;
    void Start()
    {
        if(!crossAir)
        {
            crossAir = GameObject.Find("CrossAir").GetComponent<Image>();
        }
        else
        {
            Debug.LogWarning("CrossAir no encontrada!");
        }
            
    }

    // Update is called once per frame
    void Update()
    {
        if (crossAir && playerCam)
        {
            // Raycast desde la posición de la cámara hacia adelante
            Ray ray = new Ray(playerCam.position, playerCam.forward);
            RaycastHit hit;

            // Realiza el Raycast
            if (Physics.Raycast(ray, out hit, Mathf.Infinity, obstacleLayer | targeteableLayer))
            {
                // Comprueba si el objeto impactado pertenece a targeteableLayer
                if ((targeteableLayer.value & (1 << hit.collider.gameObject.layer)) != 0)
                {
                    crossAir.color = gravitableColor; // Cambiar color a verde
                }
                // Comprueba si el objeto impactado pertenece a objectLayer
                else if ((objectLayer.value & (1 << hit.collider.gameObject.layer)) != 0)
                {
                    crossAir.color = objectColor; // Cambiar color a verde
                }
                else
                {
                    // Si impacta un obstáculo, mantener el color predeterminado
                    crossAir.color = defaultColor;
                }
            }
            else
            {
                // Si no impacta con nada, mantener el color predeterminado
                crossAir.color = defaultColor;
            }
        }
    }
}
