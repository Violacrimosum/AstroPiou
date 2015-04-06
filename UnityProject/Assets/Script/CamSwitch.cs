using UnityEngine;
using System.Collections;

public class CamSwitch : MonoBehaviour {

	public Camera[] cams;
	public GameObject scout;

	private float delta;
	// Use this for initialization
	void Start () {
		cams [0].enabled = true;
		cams [1].enabled = false;
		cams [2].enabled = false;
		cams [3].enabled = false;
		scout.SetActive(false);
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.anyKeyDown) {

		}
		delta += Time.deltaTime;
		print (delta);
		if (delta >= 80) {

		}
		else if (delta >= 74f) {
			cams [0].enabled = false;
			cams [1].enabled = false;
			cams [2].enabled = false;
			cams [3].enabled = true;
		}
		else if(delta >= 71.2f){
			cams [0].enabled = false;
			cams [1].enabled = false;
			cams [2].enabled = true;
			cams [3].enabled = false;
			scout.SetActive(true);
		}
		else if (delta >= 57.8f) {
			cams [0].enabled = false;
			cams [1].enabled = true;
			cams [2].enabled = false;
			cams [3].enabled = false;
			Vector3 tmpPos = cams[1].transform.position;
			tmpPos.x += 0.1f;
			cams[1].transform.position = tmpPos;
		}
	}
}
