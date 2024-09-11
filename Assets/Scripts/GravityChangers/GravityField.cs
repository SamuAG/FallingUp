using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.Feedbacks;

public class GravityField : MonoBehaviour
{
    [SerializeField] private float gravityForce = 9.81f;
    [SerializeField] private Vector3 gravityDirection = Vector3.down;
    [SerializeField] private Transform target = null;
    [SerializeField] MMFeedbacks feedbacks;


    private void OnTriggerEnter(Collider other)
    {
        GravityPlayerController gravityPlayerController;
        if (other.TryGetComponent<GravityPlayerController>(out gravityPlayerController))
        {
            feedbacks.PlayFeedbacks();
            gravityPlayerController.GravityForce = gravityForce;
            gravityPlayerController.GravityDirection = gravityDirection;
            gravityPlayerController.Target = target;
        }

        GravityObject gravityObject;
        if (other.TryGetComponent<GravityObject>(out gravityObject) && other.GetComponent<GravityObjectModifier>())
        {
            gravityObject.GravityForce = gravityForce;
            gravityObject.GravityDirection = gravityDirection;
            gravityObject.Target = target;
        }
    }
}
