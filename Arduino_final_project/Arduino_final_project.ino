#include <Arduino.h>
#include "LightMode.h"
#include <ESP8266Firebase.h>
#include <ESP8266WiFi.h>

#define _SSID "Wifi_P"          // Your WiFi SSID
#define _PASSWORD "21012001"      // Your WiFi Password
#define REFERENCE_URL "https://final-app-9d6ba-default-rtdb.europe-west1.firebasedatabase.app/"  // Your Firebase project reference url

Firebase firebase(REFERENCE_URL);

void setup() {
    setupLEDControl();
    WiFi.mode(WIFI_STA);
    WiFi.disconnect();
    delay(1000);
      // Connect to WiFi
  Serial.println();
  Serial.println();
  Serial.print("Connecting to: ");
  Serial.println(_SSID);
  WiFi.begin(_SSID, _PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("-");
  }

  Serial.println("");
  Serial.println("WiFi Connected");

  // Print the IP address
  Serial.print("IP Address: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
  digitalWrite(LED_BUILTIN, HIGH);
}

void loop() {
  String modo = firebase.getString("placa/luz/modo");
  String intensidad = firebase.getString("placa/luz/intensidad");
        if (modo == 0){  
            manualLED()
        }
        if (modo == 1){
            autoLED();
        }
    
}

