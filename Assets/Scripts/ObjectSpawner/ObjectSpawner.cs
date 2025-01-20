using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ObjectSpawner : MonoBehaviour
{
    [SerializeField] private GameManagerSO gM;
    [SerializeField] private GravityObject objectToSpawn;
    [SerializeField] private Transform spawnPoint;
    [SerializeField] private Material solveMaterial;
    [SerializeField] private Material dissolveMaterial;
    [SerializeField] private Vector3 gravityDirection = Vector3.down;
    [SerializeField] private Transform gravityTarget = null;
    [SerializeField] private Transform target1 = null;
    [SerializeField] private Transform target2 = null;
    [SerializeField] private float gravityForce = 9.81f;
    [SerializeField] private float speed = 2f;
    [SerializeField] private float activationDistance = 2f; // Distancia mínima para activar la gravedad
    [SerializeField] private float rotationForce = 10f;
    [SerializeField] private Vector3 torque = Vector3.zero;
    [SerializeField] private bool autoSpawn = true;
    [SerializeField] private AudioClip dissolveSound;

    private List<Material> objectMaterials;
    private bool isSceneUnloading = false;
    private GravityObject nearSpawnedObject;
    private GameObject lastSpawnedObject;
    private AudioSource audioSource;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
        if (autoSpawn) SpawnObject();
    }

    private void Update()
    {
        // Verificar si el último objeto spawneado se ha alejado lo suficiente del punto de spawn
        if (nearSpawnedObject != null)
        {
            float distance = Vector3.Distance(nearSpawnedObject.transform.position, spawnPoint.position);

            if (distance < activationDistance)
            {
                // Aplicar una pequeña fuerza de rotación al objeto
                Rigidbody rb = nearSpawnedObject.GetComponent<Rigidbody>();
                if (rb != null)
                {
                    rb.AddTorque(torque * rotationForce * Time.deltaTime, ForceMode.VelocityChange);
                }
            }
            else
            {
                nearSpawnedObject.GravityForce = gravityForce;
                nearSpawnedObject = null; // Una vez activada la gravedad, dejamos de comprobar
            }
        }

        // Suscribirse al evento OnDestroyed del objeto creado
        if (autoSpawn && lastSpawnedObject == null)
        {
            SpawnObject();
        }
    }

    public void SpawnObject()
    {
        if (spawnPoint == null || objectToSpawn == null) return;

        if (lastSpawnedObject != null && !autoSpawn)
        {
            AudioSource audio = lastSpawnedObject.AddComponent<AudioSource>();
            audio.clip = dissolveSound;
            audio.Play();

            // Desactivar el collider
            lastSpawnedObject.GetComponent<Collider>().enabled = false;

            // Quitar el objeto de las manos del jugador
            if (lastSpawnedObject.gameObject == gM.Player.GetComponent<ObjectPicker>().HeldObject)
                gM.Player.GetComponent<ObjectPicker>().DropObject();

            // Desactivar la gravedad del objeto
            GravityObjectModifier gravityObjectModifier;
            if (lastSpawnedObject.TryGetComponent<GravityObjectModifier>(out gravityObjectModifier)) gravityObjectModifier.enabled = false;

            GravityObject gravityObject;
            if (lastSpawnedObject.TryGetComponent<GravityObject>(out gravityObject)) gravityObject.GravityDirection = Vector3.zero;
            else lastSpawnedObject.GetComponent<Rigidbody>().useGravity = false;

            // Aplicar el material de disolución a todos los renderers
            AssignMaterial(GetMeshRenderersInChildren(lastSpawnedObject.transform), dissolveMaterial);

            // Comenzar la corrutina para disolver
            StartCoroutine(DissolveCoroutine(lastSpawnedObject));
        }

        GravityObject newObject = Instantiate(objectToSpawn, spawnPoint.position, spawnPoint.rotation);
        objectMaterials = GetMeshRenderersMaterials(GetMeshRenderersInChildren(newObject.transform));
        newObject.GravityDirection = gravityDirection;
        newObject.Target = gravityTarget;
        newObject.GravityForce = 0f; // Inicialmente desactivar la gravedad

        // Si son de gravedad entre dos cuerpos hay q ponerlo
        if(newObject.GetComponent<TwoBodiesGravity>() != null)
        {
            newObject.GetComponent<TwoBodiesGravity>().Target1 = target1;
            newObject.GetComponent<TwoBodiesGravity>().Target2 = target2;
        }

        // Guardar la referencia del último objeto spawneado
        nearSpawnedObject = newObject;
        lastSpawnedObject = newObject.gameObject;

        audioSource.Play();

        StartCoroutine(SolveCoroutine(AssignMaterial(GetMeshRenderersInChildren(newObject.transform), solveMaterial)));
    }

    private IEnumerator SolveCoroutine(List<MeshRenderer> _renderers)
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
                    mat.SetFloat("_Cutoff", Mathf.Lerp(1, 0, t));
                }
            }

            yield return null; // Esperar al siguiente frame
        }

        SetMeshRenderersMaterials(_renderers, objectMaterials);
    }

    private List<MeshRenderer> GetMeshRenderersInChildren(Transform parent)
    {
        List<MeshRenderer> renderers = new List<MeshRenderer>();

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
            renderers.AddRange(GetMeshRenderersInChildren(child));
        }

        return renderers;
    }

    private List<Material> GetMeshRenderersMaterials(List<MeshRenderer> renderers)
    {
        List<Material> materials = new List<Material>();

        foreach (var renderer in renderers)
        {
            Material[] mats = renderer.materials;
            foreach (var mat in mats)
            {
                materials.Add(mat);
            }
        }

        return materials;
    }

    private void SetMeshRenderersMaterials(List<MeshRenderer> renderers, List<Material> materials)
    {
        // Verificar que la cantidad de renderers y materiales coincidan
        if (renderers.Count != materials.Count)
        {
            Debug.LogError("La cantidad de renderers y materiales no coinciden. Asegúrate de que ambas listas tengan el mismo tamaño.");
            return;
        }

        for (int i = 0; i < renderers.Count; i++)
        {
            if (renderers[i] == null || materials[i] == null)
            {
                Debug.LogWarning("Uno de los renderers o materiales es nulo y se omitirá.");
                continue;
            }

            Material[] mats = renderers[i].materials;

            // Comprobar si el número de materiales en el renderer coincide con el que estamos tratando de aplicar
            if (mats.Length > 0)
            {
                // Reemplazar solo el material correspondiente al índice
                for (int j = 0; j < mats.Length && j < materials.Count; j++)
                {
                    mats[j] = new Material(materials[i]); // Crear una nueva instancia del material
                }
                renderers[i].materials = mats;
            }
            else
            {
                Debug.LogWarning($"El MeshRenderer en {renderers[i].gameObject.name} no tiene materiales asignados.");
            }
        }
    }


    private List<MeshRenderer> AssignMaterial(List<MeshRenderer> renderers, Material mat)
    {
        foreach (var renderer in renderers)
        {
            Material[] mats = renderer.materials;
            for (int i = 0; i < mats.Length; i++)
            {
                // Crear una instancia única del material
                mats[i] = new Material(mat);
            }
            renderer.materials = mats;
        }

        return renderers;
    }

    private IEnumerator DissolveCoroutine(GameObject toDissolve)
    {
        List<MeshRenderer> _renderers = GetMeshRenderersInChildren(toDissolve.transform);
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
        yield return new WaitForSeconds(dissolveSound.length);
        // Después de la disolución completa, destruir el objeto
        Destroy(toDissolve);
    }
}
