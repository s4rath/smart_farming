#include<Wire.h>
#include "DHT.h" 
#include<ESP8266WiFi.h>
#include <Servo.h>
Servo servo; 
#define D2 4  
#include <Firebase_ESP_Client.h>




 //Pin number of the LED
 #define FIREBASE_AUTH  "" //Your Firebase Web API Key
 #define FIREBASE_HOST  "" //Your Firebase URL
 #define WIFI_SSID ""     //Your WIFI SSID
 #define WIFI_PASSWORD   "1" //Your WIFI Password




#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

int SmokePin = A0; // Change this to your specific pin for the soil sensor
int SmokeValue = 0;
const int relayPin = 5;
FirebaseAuth auth;
FirebaseConfig config;
FirebaseData fbdo;
int count = 0;
bool signupOK = false;

unsigned long sendDataPrevMillis = 0;
void setup(){
    
  Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

config.api_key =  FIREBASE_AUTH;
servo.attach(D2);
  /* Assign the RTDB URL (required) */
  config.database_url = FIREBASE_HOST;
  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  //see addons/TokenHelper.h
   config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
 
  
}
void loop(){
    ////Store temperature value in variable t
  SmokeValue = analogRead(SmokePin);

   if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)){
    //since we want the data to be updated every second
    sendDataPrevMillis = millis();
    // Enter Temperature in to the DHT_11 Table
   
     if (Firebase.RTDB.setInt(&fbdo, "firebase_path/Smoke/PPM_Value",SmokeValue)){//Replace firebase_path with your firebase_path
      // This command will be executed even if you dont serial print but we will make sure its working
      Serial.println("Smoke sensor value");
  Serial.println(SmokeValue);
    }
    else {
      Serial.println("Failed to Read from the Sensor");
      Serial.println("REASON: " + fbdo.errorReason());
    }
     if (Firebase.RTDB.getInt(&fbdo,"9q0rcpcvl/WINDOW_STATUS")){ // Your Firebase data path
 int   WINDOW_STATUS = fbdo.intData();
    if(WINDOW_STATUS== 1){
      // rotate from 0 degrees to 180 degrees
    // in steps of 1 degree
       servo.write(0);                // tell servo to go to position in variable 'pos'
    delay(10);                      // waits 10ms for the servo to reach the position
  
    }
     
   
    else if (WINDOW_STATUS == 0){
      servo.write(180);                   // tell servo to go to position in variable 'pos'
    delay(10);  
                            // waits 10ms for the servo to reach the position
  
  }
     }
    else{
      Serial.println(fbdo.errorReason());
    }
   
     if (Firebase.RTDB.getInt(&fbdo,"firebase_path/LED_STATUS")){ // Your Firebase data path
 int   LED_STATUS = fbdo.intData();
    if(LED_STATUS== 1){
       digitalWrite(relayPin,LOW);
      Serial.println("LIGHT is ON");
    }
    else if (LED_STATUS == 0){
      digitalWrite(relayPin, HIGH);
      Serial.println("LIGHT is OFF");
    }
  }
    else{
      Serial.println(fbdo.errorReason());
    }
    
  }
}
   
