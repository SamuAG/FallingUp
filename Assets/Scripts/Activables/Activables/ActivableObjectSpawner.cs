using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivableObjectSpawner : MonoBehaviour, IActivable
{
    ObjectSpawner objectSpawner;
    public bool IsActive => throw new NotImplementedException();

    public event Action<bool> OnActivationChanged;

    private void Start()
    {
        objectSpawner = GetComponent<ObjectSpawner>();
        if(objectSpawner == null)
        {
            Debug.LogError("No se ha encontrado un ObjectSpawner en el objeto " + name);
            Destroy(this);
        }
    }

    public void Activate()
    {
        throw new NotImplementedException();
    }

    public void ActivateForDuration(float duration)
    {
        throw new NotImplementedException();
    }

    public void Deactivate()
    {
        throw new NotImplementedException();
    }

    public void Toggle()
    {
        objectSpawner.SpawnObject();
    }
}
