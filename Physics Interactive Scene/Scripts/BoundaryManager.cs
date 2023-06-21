using TMPro;
using UnityEngine;

/* BOUNDARY MANAGER SCRIPT */
public class BoundaryManager : MonoBehaviour
{
    // Variables
    [SerializeField] TextMeshProUGUI countText;
    void OnTriggerExit(Collider other)
    {
        // destroys the player if they have reached the boundary 
        if (other.gameObject.CompareTag("Player"))
        {
            Destroy(other.gameObject);
            SetGameOverText(); // displays the game over text when the player has crossed the boundary
        }
    }

    // sets the game over text 
    void SetGameOverText()
    {
        countText.text = "Game over -- you have entered no man's land!";
    }
}
