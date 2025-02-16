using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeAtractor : MonoBehaviour
{
    private GravityObject cube;
    [SerializeField] private string TargetTag = "Cube";

    // Update is called once per frame
    void Update()
    {
        if (cube)
        {
            if (cube.enabled)
            {
                if(Vector3.Distance(cube.transform.position, transform.position) > 0.2f)
                    cube.transform.position = Vector3.Lerp(cube.transform.position, transform.position, Time.deltaTime * 10);
                
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == TargetTag) { 
            cube = other.GetComponent<GravityObject>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == TargetTag)
        {
            cube = null;
        }
    }
}
