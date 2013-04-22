

/* Copyright (c) 2013, Benjamin James Oxley, http://www.benoxley.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.

*/

#include <OneWire.h>
#include <EEPROM.h>
#include <TrueRandom.h>
const int analogPin = A0;   // The pin that the moisture sensor is attached to
const int ledCount = 3;    // the number of LEDs in the bar graph
OneWire  ds(10);  // on pin 10
int ledPins[] = { 
  3, 4, 5};   // an array of pin numbers to which LEDs are attached
const int lenUUID = 16;
byte uuid[16];


void setup() {
  // loop over the pin array and set them all to output:
  for (int thisLed = 0; thisLed < ledCount; thisLed++) {
    pinMode(ledPins[thisLed], OUTPUT); 
  }
    Serial.begin(9600);
  if (EEPROM.read(0)=='$') {
    for (int k =  1;k<=lenUUID;k++) {
      uuid[k-1] = EEPROM.read(k);
    }
  } else {
    Serial.println("No UUID found");
    TrueRandom.uuid(uuid);
    EEPROM.write(0,'$');
    for (int k =  1;k<=lenUUID;k++) {
      EEPROM.write(k,uuid[k-1]);
    }
  }
      
}

void loop() {
  delay(5000);
  // read the potentiometer:
  long timer = millis();
  long sensorReading=0, j=0;
  while (millis() - timer < 5000) {
    delay(5);
    sensorReading += analogRead(analogPin);
    j++;
  }
  sensorReading /= j;
  
  // map the result to a range from 0 to the number of LEDs:
  int ledLevel = map(sensorReading, 200, 600, 0, ledCount);
  float voltage = sensorReading * (5.0 / 1023.0);
  float pcwater = map(sensorReading, 100, 600, 0, 50);
  pcwater = min(pcwater,50);
  pcwater = max(pcwater,0);
  // print out the value you read:
  // loop over the LED array:
  for (int thisLed = 0; thisLed < ledCount; thisLed++) {
    // if the array element's index is less than ledLevel,
    // turn the pin for this element on:
    if (thisLed < ledLevel) {
      digitalWrite(ledPins[thisLed], HIGH);
    } 
    // turn off all pins higher than the ledLevel:
    else {
      digitalWrite(ledPins[thisLed], LOW); 
    }
  }
    byte i;
  byte present = 0;
  byte type_s;
  byte data[12];
  byte addr[8];
  float celsius, fahrenheit;
  if ( !ds.search(addr)) {
    //Serial.println("No more addresses.");
    //Serial.println();
    ds.reset_search();
    delay(250);
    //return;
  }
  /*
  Serial.print("ROM =");
  for( i = 0; i < 8; i++) {
    Serial.write(' ');
    Serial.print(addr[i], HEX);
  }
  */

  if (OneWire::crc8(addr, 7) != addr[7]) {
      Serial.println("CRC is not valid!");
      return;
  }
  //Serial.println();
 
  // the first ROM byte indicates which chip
  switch (addr[0]) {
    case 0x10:
      //Serial.println("  Chip = DS18S20");  // or old DS1820
      type_s = 1;
      break;
    case 0x28:
      //Serial.println("  Chip = DS18B20");
      type_s = 0;
      break;
    case 0x22:
      //Serial.println("  Chip = DS1822");
      type_s = 0;
      break;
    default:
      Serial.println("Device is not a DS18x20 family device.");
      return;
  } 

  ds.reset();
  ds.select(addr);
  ds.write(0x44,1);         // start conversion, with parasite power on at the end
  
  delay(1000);     // maybe 750ms is enough, maybe not
  // we might do a ds.depower() here, but the reset will take care of it.
  
  present = ds.reset();
  ds.select(addr);    
  ds.write(0xBE);         // Read Scratchpad
  /*
  Serial.print("  Data = ");
  Serial.print(present,HEX);
  Serial.print(" ");
  */
  for ( i = 0; i < 9; i++) {           // we need 9 bytes
    data[i] = ds.read();
    /*
    Serial.print(data[i], HEX);
    Serial.print(" ");
    */
  }
  /*
  Serial.print(" CRC=");
  Serial.print(OneWire::crc8(data, 8), HEX);
  Serial.println();
  */
  // convert the data to actual temperature

  unsigned int raw = (data[1] << 8) | data[0];
  if (type_s) {
    raw = raw << 3; // 9 bit resolution default
    if (data[7] == 0x10) {
      // count remain gives full 12 bit resolution
      raw = (raw & 0xFFF0) + 12 - data[6];
    }
  } else {
    byte cfg = (data[4] & 0x60);
    if (cfg == 0x00) raw = raw << 3;  // 9 bit resolution, 93.75 ms
    else if (cfg == 0x20) raw = raw << 2; // 10 bit res, 187.5 ms
    else if (cfg == 0x40) raw = raw << 1; // 11 bit res, 375 ms
    // default is 12 bit resolution, 750 ms conversion time
  }
  celsius = (float)raw / 16.0;
  fahrenheit = celsius * 1.8 + 32.0;
  Serial.print("$LW");
  for (int k = 0;k<lenUUID;k++) {
  printHex(uuid[k]);
  }
  Serial.print(",");
  //Serial.print(millis());
  //Serial.print(",Celsius,");
  Serial.print(celsius);
  Serial.print(",");
  Serial.print(pcwater,1);
  Serial.print(",");
  Serial.println("NULL");
  
}

void printHex(byte number) {
  int topDigit = number >> 4;
  int bottomDigit = number & 0x0f;
  // Print high hex digit
  Serial.print( "0123456789ABCDEF"[topDigit] );
  // Low hex digit
  Serial.print( "0123456789ABCDEF"[bottomDigit] );
}

