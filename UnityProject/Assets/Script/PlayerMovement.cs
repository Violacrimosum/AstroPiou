using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class PlayerMovement : MonoBehaviour {

	public GameObject gravitySource;
	public Camera cam;

	public Camera camScreen;

	public enum GameState{
		PLAYING,
		LOOSING
	}

	private float score = 0;
	private float dashNb = 3;
	private GameState gState;
	private float oxygen;

	public Camera lossingCam;
	public Canvas gameCanvas;
	public Text scoreLabel;
	public Slider speedSlider;
	public Slider o2Slider;
	public Slider dashSlider;

	private Vector3 heading; 
	private float distance;
	private Vector3 direction;

	private Vector3 headingCam; 
	private float distanceCam;
	private Vector3 directionCam;
	
	Vector3 tmp;
	float tmpLenght;

	public float maxSpeed;//Replace with your max speed
	private float speed;
	public const float LATERAL_SPEED = 30f;
	public const float ACCELERATION = 20f;
	public const float MAX_ACCELERATION = 100.0f;

	private bool isDashing;
	private float dashTimer;

	private bool isGrounded;

	// Use this for initialization
	void Start () {
		//Init the cam
		cam = Camera.main;
		isGrounded = false;
		//this.GetComponent<Rigidbody>().Ma
		gState = GameState.PLAYING;
		oxygen = 100;
		//varaible needed for the calculation of the gravity
		heading = gravitySource.transform.position - this.transform.position;
		distance = heading.magnitude;
		direction = heading / distance;

		isDashing = false;
		dashTimer = 0;

		headingCam =  cam.transform.position - this.transform.position;
		distanceCam = headingCam.magnitude;
		directionCam = headingCam / distanceCam;

		tmp = Vector3.Cross(heading, headingCam);
		tmpLenght = tmp.magnitude;
		tmp = tmp/tmpLenght;

		dashSlider.value = dashNb;
	}

	void FixedUpdate()
	{
		if (gState == GameState.PLAYING) {
			if (this.GetComponent<Rigidbody> ().velocity.magnitude > maxSpeed) {
				this.GetComponent<Rigidbody> ().velocity = this.GetComponent<Rigidbody> ().velocity.normalized * maxSpeed;
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		/*print ("Direction : "+direction);
		print ("Distance : "+distance);
		print ("Speed : "+speed);
		print ("Distance Cam : "+distanceCam);
		print ("MoveDir "+tmp);
		print ("Speed "+this.GetComponent<Rigidbody>().velocity);*/

		//print ("Speed "+this.GetComponent<Rigidbody>().velocity.magnitude);

		print (" "+tmp);

		if (gState == GameState.PLAYING) {

			score += Time.deltaTime*10*this.GetComponent<Rigidbody>().velocity.magnitude;
			scoreLabel.text = "Score : "+score.ToString("F0");

			speedSlider.value = this.GetComponent<Rigidbody>().velocity.magnitude;

			oxygen -= Time.deltaTime;
			o2Slider.value = oxygen;



			if(isDashing){
				dashTimer += Time.deltaTime;
				if(dashTimer >= 2){
					camScreen.fieldOfView -= 10;
					if(camScreen.fieldOfView <= 60){
						this.maxSpeed = 150;
						this.GetComponent<Rigidbody> ().velocity = this.GetComponent<Rigidbody> ().velocity.normalized * maxSpeed;
						camScreen.fieldOfView = 60;
						isDashing = false;
						dashTimer = 0;
					}
				}
				else{
					camScreen.fieldOfView+= 10;
					if(camScreen.fieldOfView >= 150){
						camScreen.fieldOfView = 150;
					}
				}
			}

			if(oxygen <= 0 ){
				gState = GameState.LOOSING;
				this.GetComponent<Rigidbody>().freezeRotation = true;
				this.GetComponent<Rigidbody>().velocity = new Vector3(0,0,0);
			}
			/*if (distance >= 5004) {
				this.isGrounded = false;
			}*/


			//tmp.z = 0;
			if (!this.isGrounded) {
				this.speed += ACCELERATION;
				if (this.speed > MAX_ACCELERATION) {
					this.speed = MAX_ACCELERATION;
				}
			} else {
				this.speed = ACCELERATION;
			}

			//this.transform.position += (direction * speed);
			this.GetComponent<Rigidbody> ().AddForce (direction * speed, ForceMode.Impulse);
			//right
			if (Input.GetAxis ("Horizontal") < 0) {
				//this.cam.transform.localPosition = new Vector3(0,LATERAL_SPEED,-5);
				Vector3 tmpPos = this.transform.position + this.transform.up * 1f;
				this.transform.position = tmpPos;
			} else if (Input.GetAxis ("Horizontal") > 0) {
				//this.cam.transform.localPosition = new Vector3(0,-LATERAL_SPEED,-5);
				Vector3 tmpPos = this.transform.position - this.transform.up * 1f;
				this.transform.position = tmpPos;
			} else {
				//this.cam.transform.localPosition = new Vector3(0,0,-5);
				//this.transform.position.z += 0.2;
			}

			if (Input.GetButtonDown ("Jump")) {
				print ("Heeeyyyy !!!");
				if(this.isGrounded){
					this.GetComponent<Rigidbody> ().velocity = this.GetComponent<Rigidbody> ().velocity.normalized * (this.GetComponent<Rigidbody>().velocity.magnitude*0.2f);
					this.GetComponent<Rigidbody> ().AddForce (-direction * speed *750f, ForceMode.Impulse);

				}
			}
			else if(Input.GetButtonDown ("Fire3") && !isDashing){
				print ("Dashh !!!");
				if(dashNb > 0){
					this.maxSpeed = 400;
					this.GetComponent<Rigidbody> ().velocity = this.GetComponent<Rigidbody> ().velocity.normalized * maxSpeed * 1.5f;
					this.dashNb --;
					dashSlider.value = dashNb;
					isDashing = true;
				}
			}
			//if (this.isGrounded) {
			//this.transform.position += (tmp * 0.2f);
			this.GetComponent<Rigidbody> ().AddForce (this.transform.right * 25f, ForceMode.Acceleration);
			//}

			this.transform.localRotation = Quaternion.LookRotation (direction);

			heading = gravitySource.transform.position - this.transform.position;
			distance = heading.magnitude;
			direction = heading / distance;

			headingCam = cam.transform.position - this.transform.position;
			distanceCam = headingCam.magnitude;
			directionCam = headingCam / distanceCam;

			tmp = Vector3.Cross (heading, headingCam);
			tmpLenght = tmp.magnitude;
			tmp /= tmpLenght;
		} else if (gState == GameState.LOOSING) {
			if (Input.GetButtonDown ("Jump")) {
				
			}
			else if(Input.GetButtonDown("Cancel")){

			}
		}
	}

	void OnCollisionEnter(Collision other){
		if (other.gameObject.tag == "Obstacle") {
			gState = GameState.LOOSING;
			this.GetComponent<Rigidbody>().freezeRotation = true;
			this.GetComponent<Rigidbody>().velocity = new Vector3(0,0,0);
			camScreen.enabled = false;
			lossingCam.enabled = true;
		} else {
			isGrounded = true;
			speed = 0.02f;
		}
	}
	void OnCollisionExit(Collision other){
		//rint ("Testr");
		if (other.gameObject.tag == "Obstacle") {

		} else {
			isGrounded = false;
			//speed = 0.02f;
		}
	}
}
