#ifndef FALLMODE_H
#define FALLMODE_H

#include <Arduino.h>

// Pin definitions
#define SENSOR1_PIN D7
#define SENSOR2_PIN D8
#define LED_PIN D0 

// Threshold definition
#define FALL_THRESHOLD 100 

// Function declarations
void setupFallMode();
void loopFallMode();

#endif // FALL_MODE_H
