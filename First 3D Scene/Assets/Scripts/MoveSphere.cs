using UnityEngine;

/* MOVE SPHERE SCRIPT */
public class MoveSphere : MonoBehaviour
{
    // Variables
    private readonly float speed = 1.50f; // a speed value that adjusts how the sphere (player) moves

    void Update()
    {
        // A method that was created to make the code more readable 
        MoveWithInput();
    }

    private void MoveWithInput()
    {
        /** 
        Creates at least one moving object that uses user input (e.g. keyboard input) to move an object (or the camera) using transforms
        * @ with modifications (comments regarding these have been added accordingly) 
        * https://www.c-sharpcorner.com/article/transforming-objects-movement-using-c-sharp-scripts-in-unity/
        **/
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            this.transform.Translate(speed * Time.deltaTime * Vector3.left); // add speed value to translation 
        }

        if (Input.GetKey(KeyCode.RightArrow))
        {
            this.transform.Translate(speed * Time.deltaTime * Vector3.right); // add speed value to translation 
        }

        if (Input.GetKey(KeyCode.DownArrow))
        {
            this.transform.Translate(speed * Time.deltaTime * Vector3.down); // add speed value to translation 
        }

        if (Input.GetKey(KeyCode.UpArrow))
        {
            this.transform.Translate(speed * Time.deltaTime * Vector3.up); // add speed value to translation 
        }
    }
}
