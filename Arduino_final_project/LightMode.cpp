// LightMode.cpp

#include "LightMode.h"
#include "FirebaseGlobal.h"
#include <Arduino.h>

// Definición de variables
const int buttonPin = D4;
const int LED = D0;
int mode = 0;

BH1750 lightsensor;
char input;
bool setdatalight = false;

void setupLEDControl() {
    
    Wire.begin(4, 5); // SDA al pin D2 y SCL al pin D1
    lightsensor.begin();
    pinMode(buttonPin, INPUT);
    pinMode(LED, OUTPUT);
    delay(50);
}

int autoLED() { // Modo automático
    uint16_t lux = lightsensor.readLightLevel();
    Serial.print("Light: ");
    Serial.print(lux);
    Serial.println(" lx");
    // La función map adapta los valores del rango del sensor a los del rango del LED.
    int bright = map(lux, 0, 65535, 255, 0); // Está como 255,0 para invertir los rangos y hacer LED ON cuando hay poca luz
    int lightlevel = map(lux, 0, 65535, 0, 255);
    analogWrite(LED, bright);
    delay(500);
    return lightlevel;
}

void manualLED() { // Modo manual de 4 intensidades
   
        int pressed = digitalRead(buttonPin);
        
        if (pressed == HIGH) {
            Serial.println("pressed");
            setdatalight = true;
            if (mode == 4) {
                mode = 0;
            } else {
                mode++;
            }
            delay(200);
        }
        else{
          setdatalight = false;
        }

        FirebaseJson json;
        switch (mode) {
            case 0:
                digitalWrite(LED, LOW);
                Serial.println("LED APAGADO");
                if (setdatalight == true){
                json.add("value", mode);
                Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/manual", json) ? "ok" : fbdo.errorReason().c_str());
                }
                break;
            case 1:
                analogWrite(LED, 10);
                Serial.println("Modo LED 1");
                if (setdatalight == true){
                json.add("value", mode);
                Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/manual", json) ? "ok" : fbdo.errorReason().c_str());
                }
                break;
            case 2:
                analogWrite(LED, 64);
                Serial.println("Modo LED 2");
                if (setdatalight == true){
                json.add("value", mode);
                Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/manual", json) ? "ok" : fbdo.errorReason().c_str());
                }
                break;
            case 3:
                analogWrite(LED, 170);
                Serial.println("Modo LED 3");
                if (setdatalight == true){
                json.add("value", mode);
                Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/manual", json) ? "ok" : fbdo.errorReason().c_str());
                }
                break;
            case 4:
                analogWrite(LED, 255);
                Serial.println("Modo LED 4");
                if (setdatalight == true){
                json.add("value", mode);
                Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/light/manual", json) ? "ok" : fbdo.errorReason().c_str());
                }
                break;
        }
}

void updateLED(int updatemode) { // Modo manual de 4 intensidades
   
        switch (updatemode) {
            case 0:
                digitalWrite(LED, LOW);
                Serial.println("LED APAGADO");
                break;
            case 1:
                analogWrite(LED, 10);
                Serial.println("Modo LED 1");
                break;
            case 2:
                analogWrite(LED, 64);
                Serial.println("Modo LED 2");
                break;
            case 3:
                analogWrite(LED, 170);
                Serial.println("Modo LED 3");
                break;
            case 4:
                analogWrite(LED, 255);
                Serial.println("Modo LED 4");
                break;
        }
}
