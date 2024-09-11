using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class PlaysCrashSound : MonoBehaviour
{
    [SerializeField] private AudioClip[] crashSounds;
    AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    void OnCollisionEnter(Collision collision)
    {
        if (audioSource != null)
        {
            audioSource.clip = crashSounds[Random.Range(0, crashSounds.Length)];
            if (audioSource.isPlaying)
            {
                audioSource.Stop();
            }
            audioSource.Play();
        }
    }
}
