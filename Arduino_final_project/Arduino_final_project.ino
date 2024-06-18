#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#include "LightMode.h"
#include "FallMode.h"
#include "FaucetMode.h"
#include "FirebaseGlobal.h"

#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

//WiFi credentials 
#define WIFI_SSID "Wifi_P"
#define WIFI_PASSWORD "21012001"


//API Key
#define API_KEY "AIzaSyCCPUmzrm1pV5gAyn4BLYPQ4oaj-mimT4c"

//URL
#define DATABASE_URL "final-app-9d6ba-default-rtdb.europe-west1.firebasedatabase.app" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

//USER AUTH
#define USER_EMAIL "lopezgarciapablo21@gmail.com"
#define USER_PASSWORD "123456"

//Firebase objects
FirebaseData stream1;
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0; // Variable to set a periodic time of upload for the autoled function (to not)
int count = 0;
volatile bool dataChangedLight = false;
volatile bool dataChangedMode = false;
volatile bool dataChangedFaucet = false;
volatile bool dataChangedLightMode = false;

int modolight = 0;
int modefaucet = 0;
int modeused = -1;
int lightlevel = -1;
int lightintense = 0;

void streamCallback1(StreamData data) {
  Serial.printf("Stream1 path: %s\nEvent path: %s\nData type: %s\nEvent type: %s\n\n",
                data.streamPath().c_str(),
                data.dataPath().c_str(),
                data.dataType().c_str(),
                data.eventType().c_str());
  printResult(data); // see addons/RTDBHelper.h
  
  Serial.println();

  Serial.printf("Received stream payload size: %d (Max. %d)\n\n", data.payloadLength(), data.maxPayloadLength());
  
  if (strcmp(data.dataPath().c_str(), "/") == 0) {
    Serial.println("Data path matches /");

    if (data.dataTypeEnum() == fb_esp_rtdb_data_type_json) {
      FirebaseJson &json = data.jsonObject();
      FirebaseJsonData jsonData;

      // Extract mode value
      json.get(jsonData, "/modes/light/mode");
      if (jsonData.success) {
        modolight = jsonData.intValue;
        Serial.printf("mode: %d\n", modolight);
        
      }

      // Extract modeval value
      json.get(jsonData, "/modeval");
      if (jsonData.success) {
        modeused = jsonData.intValue;
        Serial.printf("modeval: %d\n", modeused);
        
      }

      // Extract faucetval value
      json.get(jsonData, "/modes/faucet/faucetval");
      if (jsonData.success) {
        modefaucet = jsonData.intValue;
        Serial.printf("faucetval: %d\n", modefaucet);
        
      }

      // Extract light manual value
      json.get(jsonData, "/modes/light/manual/value");
      if (jsonData.success) {
        lightintense = jsonData.intValue;
        Serial.printf("light manual value: %d\n", lightintense);
        
      }
    }
  }


  if (strcmp(data.dataPath().c_str(), "/modes/light/mode") == 0) {
    Serial.println("Data path matches /modes/light/mode");
    modolight = data.intData();
    dataChangedLight = true;
   
  } else {
    Serial.println("Data path does not match /modes/light/mode");
  }
  if (strcmp(data.dataPath().c_str(), "/modeval") == 0) {
    Serial.println("Data path matches /modeval");
    modeused = data.intData();
    dataChangedMode = true;
    
  } else {
    Serial.println("Data path does not match /board/modeval");
  }
  if (strcmp(data.dataPath().c_str(), "/modes/faucet/faucetval") == 0) {
    Serial.println("Data path matches /modes/faucet/faucetval");
    modefaucet = data.intData();
    dataChangedFaucet = true;
    
  } else {
    Serial.println("Data path does not match /modes/faucet/faucetval");
  }
  if (strcmp(data.dataPath().c_str(), "/modes/light/manual/value") == 0) {
    Serial.println("Data path matches /modes/light/manuallight/value");
    lightintense = data.intData();
    dataChangedLightMode = true;
   
  } else {
    Serial.println("Data path does not match /modes/light/manuallight/value");
  }

}


void streamTimeoutCallback1(bool timeout) {
  if (timeout)
    Serial.println("Stream1 timed out, resuming...\n");

  if (!stream1.httpConnected())
    Serial.printf("Error code: %d, reason: %s\n\n", stream1.httpCode(), stream1.errorReason().c_str());
}


void setup() {
    Serial.begin(9600);

    setupFallMode();
    setupLEDControl(); 
    setupFaucet();
    
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED) {
      Serial.print(".");
      delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  
    config.api_key = API_KEY;

  
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

  
    config.database_url = DATABASE_URL;

  
    config.token_status_callback = tokenStatusCallback; 

    Firebase.reconnectNetwork(true);

    fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

    Firebase.begin(&config, &auth);

    if (!Firebase.beginStream(stream1, "/board"))
      Serial.printf("Stream1 begin error, %s\n\n", stream1.errorReason().c_str());

    Firebase.setStreamCallback(stream1, streamCallback1, streamTimeoutCallback1);

}


void loop() {     
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 3000 || sendDataPrevMillis == 0)) {
    // Handle periodic tasks here
    sendDataPrevMillis = millis();
    //count++;
    FirebaseJson json;
    delay(100);
    if (modolight == 1){
    json.add("intensity", lightlevel);
    Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/auto", json) ? "ok" : fbdo.errorReason().c_str());
    delay(100);
    }
  }

  if (dataChangedMode){
    dataChangedMode = false;
  }
  else{
    if(modeused == 0){
      if (dataChangedFaucet) {
        dataChangedFaucet = false;
        updateFaucet(modefaucet);
      } else {
        manualFaucet();
      }
    }
    else if (modeused == 1){
      if (dataChangedLight) {
        dataChangedLight = false;
        if(modolight == 1){
          lightlevel = autoLED();
        }else if (modolight == 0){
          manualLED();
        }
      } else {
          if(modolight == 1){
            lightlevel = autoLED();
          }
          else if (modolight == 0){
            if (dataChangedLightMode){
              updateLED(lightintense);
            }else{
            manualLED();
            }
          }
      }
    } else if (modeused == 2){
      loopFallMode();
    }
  }
}