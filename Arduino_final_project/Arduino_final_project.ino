#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#include "LightMode.h"
#include "FallMode.h"
#include "FaucetMode.h"
#include "FirebaseGlobal.h"

#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Wifi_P"
#define WIFI_PASSWORD "21012001"

// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "AIzaSyCCPUmzrm1pV5gAyn4BLYPQ4oaj-mimT4c"

/* 3. Define the RTDB URL */
#define DATABASE_URL "final-app-9d6ba-default-rtdb.europe-west1.firebasedatabase.app" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that already registered or added in your project */
#define USER_EMAIL "lopezgarciapablo21@gmail.com"
#define USER_PASSWORD "123456"

// Define Firebase Data objects
FirebaseData stream1;
FirebaseData stream2;
FirebaseData stream3;
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
volatile bool dataChangedLight = false;
volatile bool dataChangedMode = false;
volatile bool dataChangedFaucet = false;
int modolight = -1;
int modefaucet = 0;
int modeused = -1;
int lightlevel = -1;

void streamCallback1(StreamData data) {
  Serial.printf("Stream1 path: %s\nEvent path: %s\nData type: %s\nEvent type: %s\n\n",
                data.streamPath().c_str(),
                data.dataPath().c_str(),
                data.dataType().c_str(),
                data.eventType().c_str());
  printResult(data); // see addons/RTDBHelper.h
  modolight = data.intData();
  Serial.println();

  Serial.printf("Received stream payload size: %d (Max. %d)\n\n", data.payloadLength(), data.maxPayloadLength());
  dataChangedLight = true;
}

void streamCallback2(StreamData data) {
  Serial.printf("Stream2 path: %s\nEvent path: %s\nData type: %s\nEvent type: %s\n\n",
                data.streamPath().c_str(),
                data.dataPath().c_str(),
                data.dataType().c_str(),
                data.eventType().c_str());
  printResult(data); // see addons/RTDBHelper.h
  modeused = data.intData();
  dataChangedMode = true;
  // Handle the data for the second stream
}

void streamCallback3(StreamData data) {
  Serial.printf("Stream3 path: %s\nEvent path: %s\nData type: %s\nEvent type: %s\n\n",
                data.streamPath().c_str(),
                data.dataPath().c_str(),
                data.dataType().c_str(),
                data.eventType().c_str());
  printResult(data); // see addons/RTDBHelper.h
  modefaucet = data.intData();
  dataChangedFaucet = true;
  // Handle the data for the second stream
}

void streamTimeoutCallback1(bool timeout) {
  if (timeout)
    Serial.println("Stream1 timed out, resuming...\n");

  if (!stream1.httpConnected())
    Serial.printf("Error code: %d, reason: %s\n\n", stream1.httpCode(), stream1.errorReason().c_str());
}

void streamTimeoutCallback2(bool timeout) {
  if (timeout)
    Serial.println("Stream2 timed out, resuming...\n");

  if (!stream2.httpConnected())
    Serial.printf("Error code: %d, reason: %s\n\n", stream2.httpCode(), stream2.errorReason().c_str());
}

void streamTimeoutCallback3(bool timeout) {
  if (timeout)
    Serial.println("Stream3 timed out, resuming...\n");

  if (!stream3.httpConnected())
    Serial.printf("Error code: %d, reason: %s\n\n", stream3.httpCode(), stream3.errorReason().c_str());
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

  /* Assign the api key (required) */
    config.api_key = API_KEY;

  /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
    config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    Firebase.reconnectNetwork(true);

    fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

    Firebase.begin(&config, &auth);

    /*if (!Firebase.beginStream(stream1, "/board/modes/light/mode"))
      Serial.printf("Stream1 begin error, %s\n\n", stream1.errorReason().c_str());

    Firebase.setStreamCallback(stream1, streamCallback1, streamTimeoutCallback1);*/

    if (!Firebase.beginStream(stream2, "/board/modeval"))
      Serial.printf("Stream2 begin error, %s\n\n", stream2.errorReason().c_str());

    Firebase.setStreamCallback(stream2, streamCallback2, streamTimeoutCallback2);

    /*if (!Firebase.beginStream(stream3, "/board/modes/faucet/faucetval"))
      Serial.printf("Stream3 begin error, %s\n\n", stream3.errorReason().c_str());

    Firebase.setStreamCallback(stream3, streamCallback3, streamTimeoutCallback3);*/
}

void loop() {     
  /*if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
    // Handle periodic tasks here
    sendDataPrevMillis = millis();
    count++;
    FirebaseJson json;
    json.add("intensity", count);
    json.add("mode", modolight);
    Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light", json) ? "ok" : fbdo.errorReason().c_str());
  }*/

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
            manualLED();
          }
      }
    } else if (modeused == 2){
      loopFallMode();
    }
  }

  if (!stream1.httpConnected()) {
    // Handle stream1 disconnection
  }

  if (!stream2.httpConnected()) {
    // Handle stream2 disconnection
  }

   if (!stream3.httpConnected()) {
    // Handle stream2 disconnection
  }
}