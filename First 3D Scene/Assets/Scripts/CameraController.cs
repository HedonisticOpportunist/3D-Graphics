using UnityEngine;

/**
 * Implements a third person camera that follows a player object
 * @ with modifications from (which have been commented below) 
 * https://learn.unity.com/tutorial/moving-the-camera?uv=2019.4&projectId=5f158f1bedbc2a0020e51f0d
 **/
public class CameraController : MonoBehaviour
{
    [SerializeField] GameObject player;
    private Vector3 offset;
    private float verticalOffset; // sets a vertical offset allows the user to see what is happening from a specific distance 


    void Start()
    {
        offset = (transform.position - player.transform.position);
        verticalOffset = Random.Range(1.5f, 2.0f); // make the vertical offset random, so that the camera is neither too close or far 
    }

    void LateUpdate()
    {
        transform.position = (player.transform.position + offset) * verticalOffset; // multiply the transform position with the vertical offset 
    }
}
