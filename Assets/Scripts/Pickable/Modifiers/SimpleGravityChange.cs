using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleGravityChange : GravityObjectModifier
{
    [SerializeField] Transform target;

    Vector3 lastDirection;

    public override void ModifyGravityPrimary()
    {
        gravityObject.GravityDirection = -gravityObject.GravityDirection;
    }

    public override void ModifyGravitySecondary()
    {
        if (!target) return;
        //gravityObject.Target = target;
        //if (gravityObject.Target)
        //{
        //    gravityObject.Target = null;
        //    gravityObject.GravityDirection = lastDirection;
        //}
        //else
        //{
        //    lastDirection = gravityObject.GravityDirection;
        //    gravityObject.Target = target;
        //}
    }
}
