#include <ESP8266WiFi.h>

 //Library for the sensor



#define WIFI_SSID "//Your wifi username"
#define WIFI_PASSWORD "//your wifi password"

#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"



// Insert Firebase project API Key
#define API_KEY ""

// Insert Firebase database url*/
#define DATABASE_URL "" 


int LdrPin = A0; // Change this to your specific pin for the soil sensor
int LdrValue = 0;



FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;
const int relayPin = 5;
unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;  
void setup() {
  Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
   digitalWrite(relayPin, LOW);
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

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
 

}

void loop() {
  LdrValue = analogRead(LdrPin);
  
   if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)){
    //since we want the data to be updated every second
    sendDataPrevMillis = millis();
   
  
   
   
   
      if (Firebase.RTDB.setInt(&fbdo, "firebase_path/Light/Ldr_Value",LdrValue)){//your firebase path
      // This command will be executed even if you dont serial print but we will make sure its working
      Serial.println("Ldr sensor value");
  Serial.println(LdrValue);
    }
    else {
      Serial.println("Failed to Read from the Sensor");
      Serial.println("REASON: " + fbdo.errorReason());
    }

      if (Firebase.RTDB.getInt(&fbdo,"firebase_path/FAN_STATUS")){ // Your Firebase data path
 int   FAN_STATUS = fbdo.intData();
    if(FAN_STATUS== 0){
      digitalWrite(relayPin, HIGH);  ;
      Serial.println("LED is ON");
    }
    else if (FAN_STATUS == 1){
      digitalWrite(relayPin, LOW);  ;
      Serial.println("LED is OFF");
    }
  }
    else{
      Serial.println(fbdo.errorReason());
    }
    
    
  }

 


  delay(3000);
}
