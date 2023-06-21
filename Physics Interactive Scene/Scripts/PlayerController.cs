using TMPro;
using UnityEngine;

/* PLAYER CONTROLLER SCRIPT */

public class PlayerController : MonoBehaviour
{
    // Variables 
    private readonly float speed = 15.0f; // speed value that is used to move the object 
    private readonly float appliedForce = 10.0f; // applied force value that is 

    private Rigidbody rigidBody;
    private int count; // the count value that is used to display the score 
    [SerializeField] TextMeshProUGUI countText; // the text display on screen 


    void Start()
    {
        /** 
		 * Task 1: Create a 3D scene including at least one object that acts under physics (e.g. a bouncing or rolling ball).
		 * @ modified from (comments have been added accordingly) 
		 * https://gist.github.com/brismithSFHS/8dd4439b3857066665d3e69c5a3b5fac
		 **/
        rigidBody = GetComponent<Rigidbody>();
        count = 0; // sets the count text to an initial value of zero 
    }

    void FixedUpdate()
    {
        MoveSphere(); // a call to the move sphere function  
    }

    private void MoveSphere()
    {
        /** 
		 * Task 2: Create a control scheme that controls the movement of an object using forces, based on user input (e.g. from keyboard input)
		 * @ modified from (comments have been added accordingly) 
		 * https://gist.github.com/brismithSFHS/8dd4439b3857066665d3e69c5a3b5fac
		 **/

        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        Vector3 movement = new(horizontalInput, 0.0f, verticalInput);

        rigidBody.AddForce(movement * speed);
        ApplyForce(); // a call to the applied force function 
    }

    private void ApplyForce()
    {
        Vector3 appliedForceVector = new(0, 0, 0);

        if (Input.GetKeyDown(KeyCode.UpArrow))
        {
            appliedForceVector = new(0.0f, appliedForce, 0.0f);

        }

        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            appliedForceVector = new(0.0f, 0.0f, appliedForce);
        }

        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            appliedForceVector = new(appliedForce, 0.0f, 0.0f);

        }

        /**
		 * Movement with physics, where is force applied to an object all at once 
		 * @ https://gamedevbeginner.com/how-to-move-objects-in-unity/#move_with_physics
		**/
        rigidBody.AddForce(appliedForceVector, ForceMode.Impulse);
    }

    void OnTriggerEnter(Collider other)
    {
        // checks if the player has collided with the pickup object
        if (other.gameObject.CompareTag("Pickup"))
        {
            other.gameObject.SetActive(false); // deletes the pickup object
            count++; // increments the score count 
            SetCurrentScoreText(); // displays the score text 
        }
    }

    // displays the current score on the screen 
    void SetCurrentScoreText()
    {
        countText.text = "Picked up items: " + count.ToString();

        if (count == 10)
        {
            countText.text = "Game over: you've caught all the rotating cubes."; // ends the game if all pickups have been collected 
        }
    }

}