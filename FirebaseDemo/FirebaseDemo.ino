/*
  Make sure your Firebase project's '.read' and '.write' rules are set to 'true'. 
  Ignoring this will prevent the MCU from communicating with the database. 
  For more details- https://github.com/Rupakpoddar/ESP8266Firebase 
*/

#include <ESP8266Firebase.h>
#include <ESP8266WiFi.h>

#define _SSID "Wifi_P"          // Your WiFi SSID
#define _PASSWORD "21012001"      // Your WiFi Password
#define REFERENCE_URL "https://final-app-9d6ba-default-rtdb.europe-west1.firebasedatabase.app/"  // Your Firebase project reference url

Firebase firebase(REFERENCE_URL);

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(1000);

  // Connect to WiFi
  Serial.println();
  Serial.println();
  Serial.print("Connecting to: ");
  Serial.println(_SSID);
  WiFi.begin(_SSID, _PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("-");
  }

  Serial.println("");
  Serial.println("WiFi Connected");

  // Print the IP address
  Serial.print("IP Address: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
  digitalWrite(LED_BUILTIN, HIGH);

//================================================================//
//================================================================//

  // Examples of setting String, integer and float values.
  //firebase.setbool("Placa/caida", true);
  firebase.setInt("Placa/grifo", 1);
  firebase.setFloat("Placa/luz", 45.32);

  // Example of getting a String.
  String data1 = firebase.getString("Example/setString");
  Serial.print("Received String:\t");
  Serial.println(data1);

  // Example of getting an int.
  int data2 = firebase.getInt("Example/setInt");
  Serial.print("Received Int:\t\t");
  Serial.println(data2);

  // Example of getting a float.
  float data3 = firebase.getFloat("Example/setFloat");
  Serial.print("Received Float:\t\t");
  Serial.println(data3);

  // Example of data deletion.
  firebase.deleteData("Example");
}

void loop() {
  // Nothing
}
