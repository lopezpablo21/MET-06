#include "FaucetMode.h"
#include "FirebaseGlobal.h"
#include <Arduino.h>

// Global variables
Servo servoMotor;
int buttonPin2 = D4; 
int emergencybutton = D5; 
int ledPin = D0;
int previousstate = LOW; 

int pressed = 0;
int emergency = 0;
int manualfaucet = 0;
bool setdata = false;



void setupFaucet() {
    servoMotor.attach(D6); // Attach the servo to the specified pin
    pinMode(buttonPin2, INPUT);
    pinMode(emergencybutton, INPUT);
    pinMode(ledPin, OUTPUT);
}

void updateFaucet(int modefaucet) {
    manualfaucet = modefaucet;
    if (modefaucet == 3){
      modefaucet = 0;
      manualfaucet = modefaucet;
    }
    switch (modefaucet) {
        case 0:
            servoMotor.write(0);
            analogWrite(ledPin, 0);
            break;
        case 1:
            servoMotor.write(90);
            analogWrite(ledPin, 100);
            break;
        case 2:
            servoMotor.write(180);
            analogWrite(ledPin, 255);
            break;
        case 3:
          servoMotor.write(0);
            analogWrite(ledPin, 0);
            break;
    }
    delay(50);
    
}

void manualFaucet() {
    pressed = digitalRead(buttonPin2); 
    emergency = digitalRead(emergencybutton); 
    FirebaseJson json;
    if (emergency == HIGH) {
        manualfaucet = 0;
        json.add("faucetval", 3);
        Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/faucet", json) ? "ok" : fbdo.errorReason().c_str());
        delay(50);
    } else {
        if (pressed == HIGH) { 
            setdata = true;
            if (manualfaucet == 2) {
                manualfaucet = 0;
            } else {
                manualfaucet = (manualfaucet + 1);
            }
            Serial.print("Modo actual: ");
            Serial.println(manualfaucet);
            delay(200);
        } else {
          setdata = false;
        }
    }
    
    switch (manualfaucet) {
        case 0:
            servoMotor.write(0);
            analogWrite(ledPin, 0);
            if (setdata == true){
            json.add("faucetval", manualfaucet);
            Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/faucet", json) ? "ok" : fbdo.errorReason().c_str());
            }
            break;
        case 1:
            servoMotor.write(90);
            analogWrite(ledPin, 100);
            
            if (setdata == true){
            json.add("faucetval", manualfaucet);
            Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/faucet", json) ? "ok" : fbdo.errorReason().c_str());
            } 
            break;
        case 2:
            servoMotor.write(180);
            analogWrite(ledPin, 255);
            
            if (setdata == true){
            json.add("faucetval", manualfaucet);
            Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/faucet", json) ? "ok" : fbdo.errorReason().c_str());
            }
            break;
    }
    delay(50);
    
}
