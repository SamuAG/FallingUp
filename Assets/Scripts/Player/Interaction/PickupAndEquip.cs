using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class PickupAndEquip : MonoBehaviour
{
    [SerializeField] private Transform playerCamera;
    [SerializeField] private Camera HandCam;
    public Transform handTransform; // La posici�n de la mano derecha donde se equipar�n los objetos
    public float pickupRange = 3.0f; // Rango de recogida

    private GameObject currentObjectInHand; // El objeto actualmente en la mano

    public GameObject CurrentObjectInHand { get => currentObjectInHand;}

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && currentObjectInHand == null)
        {
            TryPickupObject();
        }
        else if (Input.GetKeyDown(KeyCode.Q) && currentObjectInHand != null)
        {
            DropObject();
        }

        // Si el objeto en la mano tiene una funcionalidad se puede usar
        if (currentObjectInHand != null)
        {
            // remove equipment layer from player camera
            playerCamera.GetComponent<Camera>().cullingMask &= ~(1 << LayerMask.NameToLayer("Equipable"));

            HandCam.enabled = true;
            Pickupable pickupable = currentObjectInHand.GetComponent<Pickupable>();
            if (pickupable != null && Input.GetMouseButtonDown(0))
            {
                pickupable.UsePrimaryDown();
            }
            if (pickupable != null && Input.GetMouseButtonDown(1))
            {
                pickupable.UseSecondaryDown();
            }
            if (pickupable != null && Input.GetMouseButton(0))
            {
                pickupable.UsePrimary();
            }
            if (pickupable != null && Input.GetMouseButton(1))
            {
                pickupable.UseSecondary();
            }
            if (pickupable != null && Input.GetMouseButtonUp(0))
            {
                pickupable.UsePrimaryUp();
            }
            if (pickupable != null && Input.GetMouseButtonUp(1))
            {
                pickupable.UseSecondaryUp();
            }
        }
        else
        {
            HandCam.enabled = false;
            // add equipment layer to player camera
            playerCamera.GetComponent<Camera>().cullingMask |= (1 << LayerMask.NameToLayer("Equipable"));
        }
    }

    void TryPickupObject()
    {
        RaycastHit hit;
        if (Physics.Raycast(playerCamera.position, Camera.main.transform.forward, out hit, pickupRange))
        {
            if (hit.collider != null)
            {
                Pickupable pickupable;
                if (hit.collider.gameObject.TryGetComponent<Pickupable>(out pickupable)) 
                { 
                    EquipObject(pickupable.gameObject);
                }
            }
        }
    }

    public void EquipObject(GameObject obj)
    {
        currentObjectInHand = obj;
        obj.transform.SetParent(handTransform);
        obj.transform.localPosition = Vector3.zero; // Ajusta seg�n la posici�n deseada en la mano
        obj.transform.localRotation = Quaternion.identity; // Ajusta seg�n la rotaci�n deseada en la mano
        obj.GetComponent<Rigidbody>().isKinematic = true; // Desactivar f�sica para el objeto
        obj.GetComponent<Collider>().enabled = false; // Desactivar colisiones para el objeto
        obj.GetComponent<Pickupable>().Equip();
    }

    public void DropObject()
    {
        return;
        if(currentObjectInHand == null) return;

        currentObjectInHand.GetComponent<Pickupable>().Drop();
        currentObjectInHand.transform.SetParent(null);
        Rigidbody rb = currentObjectInHand.GetComponent<Rigidbody>();
        rb.isKinematic = false; // Reactivar f�sica
        currentObjectInHand.GetComponent<Collider>().enabled = true; // Reactivar colisiones
        currentObjectInHand = null;
    }
}
