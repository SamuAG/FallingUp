using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Pickupable : MonoBehaviour
{
    public abstract void UsePrimaryDown();
    public abstract void UsePrimary();
    public abstract void UsePrimaryUp();
    public abstract void UseSecondaryDown();
    public abstract void UseSecondary();
    public abstract void UseSecondaryUp();
    public abstract void Equip();
    public abstract void Drop();
}
