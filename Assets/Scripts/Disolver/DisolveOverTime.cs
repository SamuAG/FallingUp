using System.Collections;
using System.Collections.Generic;
using MoreMountains.Feedbacks;
using UnityEngine;

public class DissolveOverTime : MonoBehaviour
{
    [SerializeField] GameManagerSO gM;
    [SerializeField] private float speed = 2f; // Velocidad de disolución
    [SerializeField] private Material dissolveMaterial; // Material de disolución que se aplicará a los hijos
    [SerializeField] private LayerMask dissolvableLayerMask; // LayerMask para los objetos que pueden ser disueltos
    [SerializeField] private AudioSource audio;

    private List<MeshRenderer> renderers = new List<MeshRenderer>(); // Lista para almacenar todos los MeshRenderers

    private void OnTriggerEnter(Collider other)
    {
        // Verificar si el objeto pertenece al LayerMask de objetos disolubles
        if (((1 << other.gameObject.layer) & dissolvableLayerMask) != 0)
        {
            // Desactivar el collider
            other.enabled = false;

            // Quitar el objeto de las manos del jugador
            if (other.gameObject == gM.Player.GetComponent<ObjectPicker>().HeldObject)
                gM.Player.GetComponent<ObjectPicker>().DropObject();

            // Desactivar la gravedad del objeto
            GravityObjectModifier gravityObjectModifier;
            if (other.TryGetComponent<GravityObjectModifier>(out gravityObjectModifier)) gravityObjectModifier.enabled = false;

            GravityObject gravityObject;
            if (other.TryGetComponent<GravityObject>(out gravityObject)) gravityObject.GravityDirection = Vector3.zero;
            else other.GetComponent<Rigidbody>().useGravity = false;

            // Obtener todos los MeshRenderers del objeto que entró en el trigger
            GetMeshRenderersInChildren(other.transform);

            // Aplicar el material de disolución a todos los renderers
            foreach (var renderer in renderers)
            {
                Material[] mats = renderer.materials;
                for (int i = 0; i < mats.Length; i++)
                {
                    // Crear una instancia única del material
                    mats[i] = new Material(dissolveMaterial);
                }
                renderer.materials = mats;
            }

            audio.Play();

            // Comenzar la corrutina para disolver
            StartCoroutine(DissolveCoroutine(other.gameObject, new List<MeshRenderer>(renderers)));

            // Limpiar la lista de renderers después de iniciar la corrutina
            renderers.Clear();
        }
    }

    private IEnumerator DissolveCoroutine(GameObject toDissolve, List<MeshRenderer> _renderers)
    {
        float t = 0.0f;

        while (t < 1.0f)
        {
            t += Time.deltaTime * speed;

            foreach (var renderer in _renderers)
            {
                Material[] mats = renderer.materials;
                foreach (var mat in mats)
                {
                    // Actualizar el parámetro de disolución (_Cutoff) en el material
                    mat.SetFloat("_Cutoff", Mathf.Lerp(0, 1, t));
                }
            }

            yield return null; // Esperar al siguiente frame
        }

        // Después de la disolución completa, destruir el objeto
        Destroy(toDissolve);
    }

    private void GetMeshRenderersInChildren(Transform parent)
    {
        // Obtener todos los hijos del objeto
        foreach (Transform child in parent)
        {
            // Si el hijo tiene un MeshRenderer, añadirlo a la lista
            MeshRenderer meshRenderer = child.GetComponent<MeshRenderer>();
            if (meshRenderer != null)
            {
                renderers.Add(meshRenderer);
            }

            // Llamar recursivamente para obtener los MeshRenderers en los hijos
            GetMeshRenderersInChildren(child);
        }
    }
}
