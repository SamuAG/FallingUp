using UnityEngine;

public class Billboard : MonoBehaviour
{
    [SerializeField] private Camera targetCamera; // La c�mara a la que el objeto debe mirar
    [SerializeField] private bool lockY = false; // Si se debe bloquear la rotaci�n en el eje Y

    void Start()
    {
        // Si no se ha asignado una c�mara, usa la c�mara principal por defecto
        if (targetCamera == null)
        {
            targetCamera = Camera.main;
        }
    }

    void LateUpdate()
    {
        // Aseg�rate de que el objeto siempre est� mirando hacia la c�mara
        Vector3 directionToCamera = targetCamera.transform.position - transform.position;

        // Opcional: Desactivar la rotaci�n en el eje Y (para billboarding plano)
        if(lockY) directionToCamera.y = 0; // Si quieres que el objeto no gire hacia arriba/abajo

        // Gira el objeto hacia la c�mara
        transform.rotation = Quaternion.LookRotation(-directionToCamera);
    }
}
