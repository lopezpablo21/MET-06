#ifndef LIGHTMODE_H
#define LIGHTMODE_H

#include <Wire.h>
#include <BH1750.h>

// Variables del modo manual
extern const int buttonPin;
extern const int LED;
extern int mode;
extern int mode2;

// Variables del sensor de luz
extern BH1750 lightsensor;
extern char input;

void setupLEDControl();
void autoLED();
void manualLED();

#endif
