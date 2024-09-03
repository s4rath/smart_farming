 
#include<ESP8266WiFi.h>
#include "max6675.h"

int thermoDO = 12;//D6^
int thermoCS = 15;//D8
int thermoCLK = 14;//D5

MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);


#define WIFI_SSID "//Your wifi name"
#define WIFI_PASSWORD "//Your-wifi-password"

#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"


const int relay = 5;//D1

#define API_KEY "// Insert Firebase project API Key"


#define DATABASE_URL ""  //Insert Firebase databse URL"

int soilPin = A0; // Change this to your specific pin for the soil sensor
int soilValue = 0;
//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;                     //since we are doing an anonymous sign in 
//It is always a good idea to declare variables in the very beginning.
float t;
 

void setup(){

  pinMode(relay, OUTPUT);
  Serial.begin(9600);
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

void loop(){
//Store humidity value in variable h
  t = thermocouple.readCelsius(); ////Store temperature value in variable t
 
  
 
  Serial.println("Temperature sensor value");
  Serial.println(t);
  //temperature and humidity measured should be stored in variables so the user
  //can use it later in the database
  soilValue = analogRead(soilPin);

  // Values from 0-1024
 

  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)){
    //since we want the data to be updated every second
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.setInt(&fbdo, "firebase_path/Temperature/Celsius_Value",t)){// Your Firebase data path
      // This command will be executed even if you dont serial print but we will make sure its working
      Serial.println("Temperature sensor value");
  Serial.println(t);
    }
    else {
      Serial.println("Failed to Read from the Sensor");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    
    
    
    // Enter Temperature in to the DHT_11 Table
    if (Firebase.RTDB.setInt(&fbdo, "firebase_path/Soil/Soil_Moisture",soilValue)){// Your Firebase data path
      // This command will be executed even if you dont serial print but we will make sure its working
      Serial.println("Soil sensor value");
  Serial.println(soilValue);
    }
    else {
      Serial.println("Failed to Read from the Sensor");
      Serial.println("REASON: " + fbdo.errorReason());
    }

       if (Firebase.RTDB.getInt(&fbdo,"firebase_path/PUMP_STATUS")){ // Your Firebase data path
 int   PUMP_STATUS = fbdo.intData();
    if(PUMP_STATUS== 1){
       digitalWrite(relay,LOW);
      Serial.println("PUMP is ON");
    }
    else if (PUMP_STATUS == 0){
      digitalWrite(relay, HIGH);
      Serial.println("PUMP is OFF");
    }
  }
    else{
      Serial.println(fbdo.errorReason());
    }
   
    
  }
}
