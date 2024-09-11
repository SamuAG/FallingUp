using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DelayForMusic : MonoBehaviour
{
    AudioSource m_audio;
    [SerializeField] float delay = 1f;
    // Mi novia es una pija y me ha obligado a punta de pistola
    // a programar este script para que el audio se reproduzca
    // con un delay de 1 segundo. No me gusta hacer esto, pero
    // si no lo hago, me va a dejar sin sexo por un mes.
    IEnumerator Start()
    {
        if (m_audio = GetComponent<AudioSource>()) yield return null;

        yield return new WaitForSeconds(delay);

        m_audio.Play();
        yield return null;
    }

    
}
