using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathBarrier : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        PlayerLife playersLife;
        if (other.TryGetComponent<PlayerLife>(out playersLife))
        {
            playersLife.TakeDamage(1000);
        }
    }
}
