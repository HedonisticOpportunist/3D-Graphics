using UnityEngine;

public class MoveLeftAndRight : MonoBehaviour
{
    private readonly float speed = 2.4f; // use the speed value to determine how quickly the cube(s) move 
    private Vector3 vectorDirection = Vector3.left;

    void Update()
    {
        MoveObjectLeftAndRight();
    }

    private void MoveObjectLeftAndRight()
    {

        /** 
         * Task 1: Create a 3D scene using basic graphics techniques, laying object out using transforms
         * @ The link below was used as a reference (modifications have been commented accordingly) 
         * https://gamedevbeginner.com/how-to-move-objects-in-unity/#transform_translate
         **/
        transform.Translate(speed * Time.deltaTime * vectorDirection); // add the speed value to the translation 

        /**
         * Moves an object to the left and right 
         * 
         * https://answers.unity.com/questions/1558555/moving-an-object-left-and-right.html
         * 
         **/

        if (transform.position.x <= -4)
        {
            vectorDirection = Vector3.right * Random.Range(0.5f, 1.0f); // multiply the right vector direction with a random range 
        }
        else if (transform.position.x >= 4)
        {
            vectorDirection = Vector3.left * Random.Range(0.5f, 1.0f); // multiply the left vector direction with a random range
        }
    }
}
