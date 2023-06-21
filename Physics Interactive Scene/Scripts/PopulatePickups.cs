
using UnityEngine;

/* POPULATE PICKUP SCRIPT */
public class PopulatePickups : MonoBehaviour
{
    // Variables
    [SerializeField] GameObject spawnObject;

    void Start()
    {
        // spawns the cube ten times 
        for (int j = 0; j < 10; j++)
        {
            SpawnObject(spawnObject);
        }
    }

    private void SpawnObject(GameObject gameObject)
    {
        /** 
         * Code modified from 
         * @ (modifications are commented) 
         * https://answers.unity.com/questions/1623695/how-to-make-multiple-objects-spawn-at-random-order.html
         **/
        // the random range of the objects being spawned is within the range of the smaller plane 
        Instantiate(gameObject, new Vector3(Random.Range(-10f, 10f), 0, Random.Range(-10f, 10f)), transform.rotation);
    }

    private void OnBecameInvisible()
    {
        Destroy(gameObject); // destroys the object if it is no longer visible 
    }
}
