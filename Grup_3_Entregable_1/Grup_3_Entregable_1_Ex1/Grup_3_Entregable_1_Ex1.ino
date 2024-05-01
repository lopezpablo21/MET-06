#include <Wire.h>
#include <BH1750.h>

// Variables del mode manual
const int buttonPin = D6;
const int LED = D0;
int mode = 0;
int mode2 = 3;

// Variables del sensor de llum
BH1750 lightsensor;
char input;

void setup() {
  Serial.begin(9600);
  Wire.begin(4, 5); // SDA al pin D2 i SCL al pin D1
  lightsensor.begin(); 
  pinMode(buttonPin, INPUT);
  pinMode(LED, OUTPUT);
  delay(50);
  Serial.println("\n Type 'a' for auto mode or 'm' for manual mode.");
}

void loop() {
  if (Serial.available() > 0) { // Per només canviar el mode quan hi ha un input character
    input = Serial.read();
    if (input != '\n') { // Per evitar l'error quan entra el valor de l'enter
      if (input == 'a') {
        mode2 = 0;
        Serial.println("Automatic Mode");
        autoLED();
      } else if (input == 'm') {
        mode2 = 1;
        Serial.println("Manual Mode");
        manualLED();
      } else if ((input == 's') || (mode2 == 3)){
        mode2 = 3;
        Serial.println("No Mode selected. Type 'a' for auto mode or 'm' for manual mode. Type 's' to stop");
      } else {
        Serial.println("Invalid input. Type 'a' for auto mode or 'm' for manual mode.");
      }
    }
  }
  else { // Per fer el bucle quan hi un mode seleccionat
    if (mode2 == 0){
    autoLED();
    }
    if (mode2 == 1){
    manualLED();
    }
  }
}

void autoLED() { // Mode automàtic
  uint16_t lux = lightsensor.readLightLevel();
  Serial.print("Light: ");
  Serial.print(lux);
  Serial.println(" lx");
  // La funció map adapta els valors del rang del sensor als del rang del LED.
  int bright = map(lux, 0, 65535, 255, 0); // Està com a 255,0 per invertir els rangs i fer LED ON quan hi ha poca llum
  analogWrite(LED, bright);
  delay(500); 
}

void manualLED() { // Mode manual de 4 intensitats
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
