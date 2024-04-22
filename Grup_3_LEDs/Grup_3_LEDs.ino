const int buttonPin = 4;
const int greenLED = 5;
const int yellowLED = 16;
const int redLED = 2;

int pressed = 0;
int mode = 0;

void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(greenLED, OUTPUT);
  pinMode(yellowLED, OUTPUT);
  pinMode(redLED, OUTPUT);
}

void loop() {
  pressed = digitalRead(buttonPin);

  if (pressed == HIGH) {
    if (mode == 3){
      mode = 0;
    }
    else{
    mode = (mode + 1);
    }
    delay(200); 
  }

  switch (mode) {
    case 0:
      digitalWrite(greenLED, LOW);
      digitalWrite(yellowLED, LOW);
      digitalWrite(redLED, LOW);
      break;
    case 1:
      digitalWrite(greenLED, HIGH);
      digitalWrite(yellowLED, LOW);
      digitalWrite(redLED, LOW);
      
      break;
    case 2:
      digitalWrite(greenLED, HIGH);
      digitalWrite(yellowLED, HIGH);
      digitalWrite(redLED, LOW);
      break;
    case 3:
      digitalWrite(greenLED, HIGH);
      digitalWrite(yellowLED, HIGH);
      digitalWrite(redLED, HIGH);
  }
}
