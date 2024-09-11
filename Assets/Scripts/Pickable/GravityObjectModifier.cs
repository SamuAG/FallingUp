using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(GravityObject))]
public abstract class GravityObjectModifier : MonoBehaviour
{
    protected GravityObject gravityObject;

    // Start is called before the first frame update
    protected virtual void Start()
    {
        gravityObject = GetComponent<GravityObject>();
        if (gravityObject == null)
        {
            Debug.LogError("GravityObject no encontrado en " + gameObject.name);
        }
    }

    public abstract void ModifyGravityPrimary();
    public abstract void ModifyGravitySecondary();
}
