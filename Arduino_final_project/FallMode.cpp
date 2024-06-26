#include "FallMode.h"
#include "FirebaseGlobal.h"

// State variables
bool sensor1State = false;
bool sensor2State = false;
bool fallDetected = false;

unsigned long sensor1LastMotionTime = 0;
unsigned long sensor2LastMotionTime = 0;
FirebaseJson json;

void setupFallMode() {
  Serial.begin(9600);
  
  pinMode(SENSOR1_PIN, INPUT);
  pinMode(SENSOR2_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);

  digitalWrite(LED_PIN, LOW);
}

void loopFallMode() {
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
      json.add("falled", fallDetected);
      Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/fall", json) ? "ok" : fbdo.errorReason().c_str());
      delay(10000);
    }
  }

  if (!sensor1State && !sensor2State && fallDetected) {
    // Reset fall detection flag and turn off the LED
    fallDetected = false;
    json.add("falled", fallDetected);
    Serial.printf("Set json... %s\n\n", Firebase.setJSON(fbdo, "/board/modes/fall", json) ? "ok" : fbdo.errorReason().c_str());
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
