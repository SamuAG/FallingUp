using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivableText : MonoBehaviour, IActivable
{
    private bool isActive = false;
    [SerializeField] private TMPro.TMP_Text m_Text;

    public bool IsActive => isActive;

    public event Action<bool> OnActivationChanged;

    public void Activate()
    {
        if (!IsActive)
        {
            isActive = true;
            m_Text.enabled = true;
        }
    }

    public void ActivateForDuration(float duration)
    {
        throw new NotImplementedException();
    }

    public void Deactivate()
    {
        if (IsActive)
        {
            isActive = false;
            m_Text.enabled = false;
        }
    }

    public void Toggle()
    {
        if (isActive)
        {
            Deactivate();
        }
        else
        {
            Activate();
        }
    }
}
