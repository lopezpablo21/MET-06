const int buttonPin = 14;
const int LED = 12;

int pressed = 0;
int mode = 0;

void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(LED, OUTPUT);
}

void loop() {
  pressed = digitalRead(buttonPin);

  if (pressed == HIGH) {
    if (mode == 4){
      mode = 0;
    }
    else{
    mode = (mode + 1);
    }
    delay(200); 
  }

  switch (mode) {
    case 0:
      digitalWrite(LED, LOW);
      break;
    case 1:
      analogWrite(LED, 10);
      break;
    case 2:
      analogWrite(LED, 64);
      break;
    case 3:
      analogWrite(LED, 170);
    case 4:
      analogWrite(LED, 255);
  }
}

