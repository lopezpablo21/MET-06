
#define SENSOR1_PIN D7
#define SENSOR2_PIN D8
#define LED_PIN D0 

#define FALL_THRESHOLD 100 

bool sensor1State = false;
bool sensor2State = false;
bool fallDetected = false;

unsigned long sensor1LastMotionTime = 0;
unsigned long sensor2LastMotionTime = 0;

void setup() {
  
  Serial.begin(9600);

  
  pinMode(SENSOR1_PIN, INPUT);
  pinMode(SENSOR2_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);

  digitalWrite(LED_PIN, LOW);
}

void loop() {
  
  sensor1State = digitalRead(SENSOR1_PIN);
  sensor2State = digitalRead(SENSOR2_PIN);


  if (sensor1State == HIGH && !sensor2State) {
    sensor1LastMotionTime = millis();
  }

  if (sensor2State == HIGH && sensor1State == HIGH) {
  
    sensor2LastMotionTime = millis();
   
    unsigned long timeDifference = sensor2LastMotionTime - sensor1LastMotionTime;
 
    if (timeDifference <= FALL_THRESHOLD && !fallDetected) {
   
      digitalWrite(LED_PIN, HIGH);
      Serial.println("Fall detected!");
      fallDetected = true;
    }
  }

  if (!sensor1State && !sensor2State && fallDetected) {
    // Reset fall detection flag and turn off the LED
    fallDetected = false;
    digitalWrite(LED_PIN, LOW);
    Serial.println("Yaya revived");
  }

  Serial.print("Sensor 1: ");
  Serial.print(sensor1State);
  Serial.print(", Sensor 2: ");
  Serial.print(sensor2State);
  Serial.println();

  delay(100);
}
