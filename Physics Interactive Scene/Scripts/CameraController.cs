using UnityEngine;

/**
 * Implements a third person camera that follows a moving object
 * @ with modifications (that have been commented below)
 * https://learn.unity.com/tutorial/moving-the-camera?uv=2019.4&projectId=5f158f1bedbc2a0020e51f0d
 **/

/* CAMERA CONTROLLER SCRIPT */
public class CameraController : MonoBehaviour
{
    [SerializeField] GameObject player;
    private Vector3 offset;


    void Start()
    {
        offset = transform.position - player.transform.position;
    }

    void LateUpdate()
    {
        if (player != null)
        {
            transform.position = (player.transform.position + offset);
        }
    }

    // removes the pickup object if it collides with the player 
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Pickup"))
        {
            other.gameObject.SetActive(false);
        }
    }
}
