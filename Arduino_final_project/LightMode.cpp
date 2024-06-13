#include "LightMode.h"
#include <Arduino.h>

// Definición de variables
const int buttonPin = D6;
const int LED = D0;
int mode = 0;
int mode2 = 3;
BH1750 lightsensor;
char input;

void setupLEDControl() {
    Serial.begin(9600);
    Wire.begin(4, 5); // SDA al pin D2 y SCL al pin D1
    lightsensor.begin();
    pinMode(buttonPin, INPUT);
    pinMode(LED, OUTPUT);
    delay(50);
    Serial.println("\nType 'a' for auto mode or 'm' for manual mode.");
}

void autoLED() { // Modo automático
    uint16_t lux = lightsensor.readLightLevel();
    Serial.print("Light: ");
    Serial.print(lux);
    Serial.println(" lx");
    // La función map adapta los valores del rango del sensor a los del rango del LED.
    int bright = map(lux, 0, 65535, 255, 0); // Está como 255,0 para invertir los rangos y hacer LED ON cuando hay poca luz
    analogWrite(LED, bright);
    delay(500);
}

void manualLED() { // Modo manual de 4 intensidades
    int pressed = digitalRead(buttonPin);
    
    if (pressed == HIGH) {
        if (mode == 4) {
            mode = 0;
        } else {
            mode++;
        }
        delay(200);
    }

    switch (mode) {
        case 0:
            digitalWrite(LED, LOW);
            Serial.println("LED OFF");
            break;
        case 1:
            analogWrite(LED, 10);
            Serial.println("LED mode 1");
            break;
        case 2:
            analogWrite(LED, 64);
            Serial.println("LED mode 2");
            break;
        case 3:
            analogWrite(LED, 170);
            Serial.println("LED mode 3");
            break;
        case 4:
            analogWrite(LED, 255);
            Serial.println("LED mode 4");
            break;
    }
}
