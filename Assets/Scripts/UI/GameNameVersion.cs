using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameNameVersion : MonoBehaviour
{
    TMPro.TMP_Text text;
    void Start()
    {
        GetComponent<TMPro.TMP_Text>().text = Application.productName + " " + Application.version;
    }
}
