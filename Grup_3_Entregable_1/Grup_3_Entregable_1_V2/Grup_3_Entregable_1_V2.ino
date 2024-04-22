#include <Wire.h>
#include <BH1750.h>

BH1750 Luxometro(0x23); //para una dirección i2C de 0x23



void setup(){
  Serial.begin(9600);
  Wire.begin(5,4);
  Serial.println("Inicializando sensor...");
  Luxometro.begin(BH1750::CONTINUOUS_HIGH_RES_MODE); //inicializamos el sensor
}


void loop() {
  uint16_t lux = Luxometro.readLightLevel();//Realizamos una lectura del sensor
  Serial.print("Luz(iluminancia):  ");
  Serial.print(lux);
  Serial.println(" lx");
  delay(500);
}
