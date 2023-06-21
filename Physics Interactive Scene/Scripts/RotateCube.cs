using UnityEngine;

/* ROTATE CUBE SCRIPT */
public class RotateCube : MonoBehaviour
{
    void Update()
    {
        // rotates the cube 
        transform.Rotate(new Vector3(15, 30, 45) * Time.deltaTime);
    }
}