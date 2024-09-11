using UnityEngine;

public class Billboard : MonoBehaviour
{
    [SerializeField] private Camera targetCamera; // La cámara a la que el objeto debe mirar
    [SerializeField] private bool lockY = false; // Si se debe bloquear la rotación en el eje Y

    void Start()
    {
        // Si no se ha asignado una cámara, usa la cámara principal por defecto
        if (targetCamera == null)
        {
            targetCamera = Camera.main;
        }
    }

    void LateUpdate()
    {
        // Asegúrate de que el objeto siempre esté mirando hacia la cámara
        Vector3 directionToCamera = targetCamera.transform.position - transform.position;

        // Opcional: Desactivar la rotación en el eje Y (para billboarding plano)
        if(lockY) directionToCamera.y = 0; // Si quieres que el objeto no gire hacia arriba/abajo

        // Gira el objeto hacia la cámara
        transform.rotation = Quaternion.LookRotation(-directionToCamera);
    }
}
