using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using MoreMountains.Feedbacks;
using QFSW.QC;

public class PlayerLife : MonoBehaviour
{
    [SerializeField] private int maxHealth = 100; // Vida máxima del jugador
    private int currentHealth;

    [SerializeField] private GameObject playerCamera; // Referencia a la cámara del jugador
    [SerializeField] private float fallSpeed = 2f; // Velocidad a la que la cámara cae al suelo
    [SerializeField] private float deathDelay = 2f; // Tiempo de espera antes de fundir a negro
    [SerializeField] private float fadeSpeed = 1f; // Velocidad del fundido
    [SerializeField] MMFeedbacks feedbacks;

    private bool isDead = false;

    void Start()
    {
        currentHealth = maxHealth;
    }

    void Update()
    {
        if (isDead) return;

        // Chequear si la vida ha llegado a 0
        if (currentHealth <= 0)
        {
            Die();
        }
    }

    [Command("take-damage")]
    public void TakeDamage(int amount)
    {
        if (isDead) return;

        currentHealth -= amount;

        if (currentHealth <= 0)
        {
            currentHealth = 0;
            Die();
        }
    }

    [Command("kill")]
    public void Die()
    {
        feedbacks.PlayFeedbacks();

        isDead = true;

        DisablePlayerControls();

        StartCoroutine(FallToGround());
    }

    private void DisablePlayerControls()
    {
        var playerController = GetComponent<GravityPlayerController>();
        var objectPicker = GetComponent<ObjectPicker>();
        var pickupAndEquip = GetComponent<PickupAndEquip>();
        var playerInteract = GetComponent<PlayerInteract>();
        var colliders = GetComponents<Collider>();
        
        if (playerController != null)
        {
            playerController.enabled = false;
        }
        if (objectPicker != null)
        {
            objectPicker.DropObject();
            objectPicker.enabled = false;
        }
        if (pickupAndEquip != null)
        {
            pickupAndEquip.DropObject();
            pickupAndEquip.enabled = false;
        }
        if (playerInteract != null)
        {
            playerInteract.enabled = false;
        }
        if (colliders != null)
        {
            foreach (var collider in colliders)
            {
                collider.enabled = false;
            }
        }
    }

    private IEnumerator FallToGround()
    {
        playerCamera.AddComponent<BoxCollider>();
        Rigidbody camRb = playerCamera.AddComponent<Rigidbody>();
        camRb.velocity = GetComponent<Rigidbody>().velocity;
        GravityObject camGravity = playerCamera.AddComponent<GravityObject>();
        camGravity.GravityForce = GetComponent<GravityPlayerController>().GravityForce;
        camGravity.GravityDirection = GetComponent<GravityPlayerController>().GravityDirection;
        camGravity.Target = GetComponent<GravityPlayerController>().Target;



        // Esperar unos segundos adicionales antes de iniciar el fundido
        yield return new WaitForSeconds(deathDelay);

        // Iniciar el fundido a negro
        Initiate.Fade(SceneManager.GetActiveScene().name, Color.black, fadeSpeed);
    }

}
