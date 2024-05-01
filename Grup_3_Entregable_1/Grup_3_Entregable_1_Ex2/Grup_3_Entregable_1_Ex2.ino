#include <Servo.h>

Servo servoMotor;
int buttonPin = D6; 
int emergencybutton = D8; 
int previousstate = LOW; 
int mode = 0; 
int ledPin = D0;
int pressed = 0;
int emergency = 0;

void setup() {
  Serial.begin(9600);
  servoMotor.attach(D7); //Per indicar a quin port es troba el servo
  pinMode(buttonPin, INPUT);
  pinMode(emergencybutton, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  pressed = digitalRead(buttonPin); // Cada cop que es presiona el mode button
  emergency = digitalRead(emergencybutton); // Quan es preiona el emergency button

  if (emergency == HIGH) {
    servoMotor.write(0);
    delay(50); 
  } else {
    if (pressed == HIGH) { 
      if (mode == 2){
      mode = 0;
      }
      else {
        mode =(mode + 1);
      }
      Serial.print("Modo actual: ");
      Serial.println(mode);
      delay(200);
    }
  }

  switch (mode) { // Selecció de modes
    case 0:
      servoMotor.write(0); 
      analogWrite(ledPin, 0); // LED apagat
      break;
    case 1:
      servoMotor.write(90); 
      analogWrite(ledPin, 100); // LED a meitat d'intensitat
      break;
    case 2:
      servoMotor.write(180); 
      analogWrite(ledPin, 255); // LED a full intensitat
      break;
  }
  delay(50);
}