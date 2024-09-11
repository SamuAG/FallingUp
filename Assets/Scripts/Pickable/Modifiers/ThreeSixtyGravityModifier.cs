using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThreeSixtyGravityModifier : GravityObjectModifier
{
    [SerializeField] private Vector3[] gravityDirections = new Vector3[]
    {
        new Vector3(1, 0, 0),  // X positivo
        new Vector3(0, 1, 0),  // Y positivo
        new Vector3(0, 0, 1),  // Y positivo
        new Vector3(-1, 0, 0),  // Y positivo
        new Vector3(0, -1, 0), // Y negativo
        new Vector3(0, 0, -1)  // Z negativo
    };
    private int currentAxisIndex = 0;

    public override void ModifyGravityPrimary()
    {
        gravityObject.GravityDirection = gravityDirections[currentAxisIndex];
        currentAxisIndex = (currentAxisIndex + 1) % gravityDirections.Length;
    }

    public override void ModifyGravitySecondary()
    {
        return;
    }
}
