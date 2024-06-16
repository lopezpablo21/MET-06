#include "FaucetMode.h"
#include <Arduino.h>

// Global variables
Servo servoMotor;
int buttonPin2 = D6; 
int emergencybutton = D8; 
int previousstate = LOW; 
int modefaucet = 0; 
int ledPin = D0;
int pressed = 0;
int emergency = 0;

void setupFaucet() {
    servoMotor.attach(D7); // Attach the servo to the specified pin
    pinMode(buttonPin2, INPUT);
    pinMode(emergencybutton, INPUT);
    pinMode(ledPin, OUTPUT);
}

void updateFaucet() {
    pressed = digitalRead(buttonPin2); 
    emergency = digitalRead(emergencybutton); 

    if (emergency == HIGH) {
        servoMotor.write(0);
        delay(50);
    } else {
        if (pressed == HIGH) { 
            if (modefaucet == 2) {
                modefaucet = 0;
            } else {
                modefaucet = (modefaucet + 1);
            }
            Serial.print("Modo actual: ");
            Serial.println(modefaucet);
            delay(200);
        }
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
    }
    delay(50);
}
