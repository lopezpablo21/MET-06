#ifndef LIGHTMODE_H
#define LIGHTMODE_H

#include <Wire.h>
#include <BH1750.h>
#include <ESP8266Firebase.h>
// Variables del modo manual
extern const int buttonPin;
extern const int LED;
extern int mode;

// Variables del sensor de luz
extern BH1750 lightsensor;
extern char input;

void setupLEDControl();
int autoLED();
void manualLED();

#endif
