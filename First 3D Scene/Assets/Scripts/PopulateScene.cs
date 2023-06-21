
using UnityEngine;

/* POPULATE SCENE SCRIPT */
public class PopulateScene : MonoBehaviour
{
    // Variables
    [SerializeField] GameObject cube;

    void Start()
    {
        // the for loop was added to ensure that an object is created a certain number of times 
        for (int j = 0; j < 4; j++)
        {
            SpawnObject(cube);
        }
    }

    // the function was created, so that the spawn object code could be reused for other objects 
    private void SpawnObject(GameObject gameObject)
    {
        /** 
         * Code modified from (comments have been added accordingly) 
         * https://answers.unity.com/questions/1623695/how-to-make-multiple-objects-spawn-at-random-order.html
         **/
        // the random range of the vector is kept small so that the user can see the cubes moving back and forth 
        Instantiate(gameObject, new Vector3(Random.Range(-5f, 5f), 0, Random.Range(-5f, 5f)), transform.rotation);
    }

    private void OnBecameInvisible()
    {
        Destroy(gameObject); // destroys the object if it is no longer visible 
    }
}
