using MoreMountains.Feedbacks;
using System.Collections;
using UnityEngine;

public class GravityGun : Pickupable
{
    [SerializeField] GameManagerSO gameManager;
    [SerializeField] MMFeedbacks feedbacks;
    [SerializeField] LineRenderer line;
    [SerializeField] float timeRay = 0.7f;
    [SerializeField] LayerMask layerMask;
    [SerializeField] Animator anim;

    GravityObject gravityObject;
    private GravityPlayerController playerGravity;

    private void Start()
    {
        line.enabled = false;
    }

    public override void Drop()
    {
        if (!gravityObject) gravityObject = GetComponent<GravityObject>();
        if (!playerGravity) playerGravity = gameManager.Player.GetComponent<GravityPlayerController>();

        gravityObject.GravityDirection = playerGravity.GravityDirection;
        gravityObject.GravityForce = playerGravity.GravityForce;
    }

    public override void Equip()
    {

    }

    public override void UsePrimary()
    {

    }

    public override void UsePrimaryDown()
    {
        if(Time.timeScale == 0) return;
        if (!playerGravity) playerGravity = gameManager.Player.GetComponent<GravityPlayerController>();

        StopAllCoroutines();
        StartCoroutine(DrawAndDisableLine());

        feedbacks.PlayFeedbacks();
        if(anim) anim.SetTrigger("Shoot");

        if (Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out RaycastHit hit, Mathf.Infinity, layerMask))
        {
            SetLineRendererPosition(hit.point);  // Establecer la posición final del rayo en el punto de impacto

            if (hit.collider != null && hit.transform.CompareTag("targeteable") && !IsInLayer(hit.transform.gameObject, "PickUp") && IsInLayer(hit.transform.gameObject, "Gravitable"))
            {
                playerGravity.IsTargetRepulsor = false;
                playerGravity.Target = hit.transform;
            }
            else if (hit.collider != null && !IsInLayer(hit.transform.gameObject, "PickUp") && IsInLayer(hit.transform.gameObject, "Gravitable"))
            {
                playerGravity.Target = null;
                playerGravity.GravityDirection = -hit.normal;
            }
        }
        else
        {
            SetLineRendererPosition(Camera.main.transform.position + Camera.main.transform.forward * 100);
        }
        
    }

    public override void UsePrimaryUp()
    {

    }

    public override void UseSecondary()
    {

    }

    public override void UseSecondaryDown()
    {
        if (Time.timeScale == 0) return;
        if (!playerGravity) playerGravity = gameManager.Player.GetComponent<GravityPlayerController>();

        StopAllCoroutines();
        StartCoroutine(DrawAndDisableLine());

        feedbacks.PlayFeedbacks();
        if (anim) anim.SetTrigger("ShootObject");

        if (Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out RaycastHit hit, Mathf.Infinity, layerMask))
        {
            SetLineRendererPosition(hit.point);  // Establecer la posición final del rayo en el punto de impacto

            if (hit.transform.TryGetComponent(out GravityObjectModifier gravityObjectModifier))
            {
                gravityObjectModifier.ModifyGravityPrimary();
            }
        }
        else
        {
            SetLineRendererPosition(Camera.main.transform.position + Camera.main.transform.forward * 100);
        }
        
    }

    public override void UseSecondaryUp()
    {

    }

    private bool IsInLayer(GameObject obj, string layerName)
    {
        return obj.layer == LayerMask.NameToLayer(layerName);
    }

    private void LateUpdate()
    {
        if (line.enabled)
        {
            line.SetPosition(0, line.transform.position);
            line.SetPosition(1, line.GetPosition(1));  // Mantener la posición establecida en DrawAndDisableLine
        }
    }

    private IEnumerator DrawAndDisableLine()
    {
        line.enabled = true;

        line.SetPosition(0, line.transform.position);

        // Esperar 0.7 segundos o el tiempo que hayas configurado
        yield return new WaitForSeconds(timeRay);

        // Desactivar el LineRenderer
        line.enabled = false;

        if (anim) anim.ResetTrigger("Shoot");
        if (anim) anim.ResetTrigger("ShootObject");
    }

    private void SetLineRendererPosition(Vector3 endPosition)
    {
        line.SetPosition(1, endPosition);  // Establecer la posición final del LineRenderer en el punto de impacto
    }
}
