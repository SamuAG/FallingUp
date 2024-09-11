using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestPuckupable : Pickupable
{
    public override void Drop()
    {
        throw new System.NotImplementedException();
    }

    public override void Equip()
    {
        throw new System.NotImplementedException();
    }

    public override void UsePrimary()
    {
        Debug.Log("User is using the Pickupable primary");
    }

    public override void UsePrimaryDown()
    {
        throw new System.NotImplementedException();
    }

    public override void UsePrimaryUp()
    {
        throw new System.NotImplementedException();
    }

    public override void UseSecondary()
    {
        Debug.Log("User is using the Pickupable secondary");
    }

    public override void UseSecondaryDown()
    {
        throw new System.NotImplementedException();
    }

    public override void UseSecondaryUp()
    {
        throw new System.NotImplementedException();
    }
}
