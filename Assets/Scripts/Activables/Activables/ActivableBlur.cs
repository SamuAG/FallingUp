using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivableBlur : MonoBehaviour, IActivable
{
    [SerializeField] private float blurSpeed = 2f; 
    [SerializeField] private float deBlurSpeed = 2f;
    [SerializeField] private Renderer[] renderers;
    [SerializeField] private Collider blurCollider;

    private bool isActive = false;

    public bool IsActive => isActive;

    public event Action<bool> OnActivationChanged;

    public void Activate()
    {
        if (!isActive)
        {
            isActive = true;
            OnActivationChanged?.Invoke(isActive);
            StopAllCoroutines();
            StartCoroutine(DeBlur(deBlurSpeed));
        }
    }

    public void Deactivate()
    {
        if (isActive)
        {
            isActive = false;
            OnActivationChanged?.Invoke(isActive);
            StopAllCoroutines();
            StartCoroutine(Blur(blurSpeed));
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

    public void ActivateForDuration(float duration)
    {
        Activate();
        StartCoroutine(DeactivateAfterDuration(duration));
    }

    private IEnumerator DeactivateAfterDuration(float duration)
    {
        yield return new WaitForSeconds(duration);
        Deactivate();
    }

    private IEnumerator Blur( float speed)
    {
        float t = 0.0f;

        while (t < 1.0f)
        {
            t += Time.deltaTime * speed;

            foreach (var renderer in renderers)
            {
                Material[] mats = renderer.materials;
                foreach (var mat in mats)
                {
                    mat.SetFloat("_BlurAmount", Mathf.Lerp(0, 0.03f, t));
                }
            }

            yield return null; // Esperar al siguiente frame
        }

        blurCollider.enabled = true;
    }

    private IEnumerator DeBlur(float speed)
    {
        float t = 0.0f;

        while (t < 1.0f)
        {
            t += Time.deltaTime * speed;

            foreach (var renderer in renderers)
            {
                Material[] mats = renderer.materials;
                foreach (var mat in mats)
                {
                    mat.SetFloat("_BlurAmount", Mathf.Lerp(0.03f, 0, t));
                }
            }

            yield return null; // Esperar al siguiente frame
        }

        blurCollider.enabled = false;
    }
}
