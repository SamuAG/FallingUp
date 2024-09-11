using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioTriggerOnCollision : MonoBehaviour
{
    [SerializeField] private bool playOnce = true;
    [SerializeField] private AudioClip audioClip;
    private bool hasPlayed = false;

    private AudioSource m_audio;
    private void Start()
    {
        m_audio = GameObject.Find("SoundManager")?.GetComponent<AudioSource>();
        if (m_audio == null)
        {
            Debug.LogError("No hay soundmanager, problablemente estas ejecutando la escena del nivel y no la de base :)");
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (m_audio != null && other.GetComponent<PlayerBasics>() && !hasPlayed && !m_audio.isPlaying)
        {
            m_audio.clip = audioClip;
            m_audio.Play();

            if (playOnce)
            {
                hasPlayed = true;
            }
        }
    }
}
