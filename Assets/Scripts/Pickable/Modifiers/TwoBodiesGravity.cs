using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TwoBodiesGravity : GravityObjectModifier
{
    [SerializeField] Transform currentTarget;
    [SerializeField] Transform target1;
    [SerializeField] Transform target2;

    Vector3 lastDirection;

    public Transform Target1 { get => target1; set => target1 = value; }
    public Transform Target2 { get => target2; set => target2 = value; }

    public override void ModifyGravityPrimary()
    {
        currentTarget = gravityObject.Target;
        if (currentTarget == null) return;

        if (currentTarget == target1) currentTarget = target2;
        else if (currentTarget == target2) currentTarget = target1;

        gravityObject.Target = currentTarget;
    }

    public override void ModifyGravitySecondary()
    {
        
        
    }
}