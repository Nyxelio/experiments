/* Read voltage divider
 * Reads the voltage divider to calculate a battery voltage
 */

int batMonPin = 0;    // input pin for the divider
int ledBatMonPin = 13;
int val = 0;       // variable for the A/D value
float pinVoltage = 0; // variable to hold the calculated voltage
//float batteryVoltage = 0;
float batteryPercent = 0;
float ratio = 4.68;

void setup() {
  
  
  pinMode(ledBatMonPin,OUTPUT);
  
  Serial.begin(9600);      // open the serial port at 9600 baud
  
  
}

void loop() {  
  
  batteryMonitor();
  
  delay(1000);                  //  Slow it down
}

void batteryMonitor()
{
  val = analogRead(batMonPin);    // read the voltage on the divider  
  
  pinVoltage = val * 0.00488;       //  Calculate the voltage on the A/D pin
                                    //  A reading of 1 for the A/D = 0.0048mV
                                    //  if we multiply the A/D reading by 0.00488 then 
                                    //  we get the voltage on the pin.                                  
                                    
                                    
  
  //batteryVoltage = pinVoltage * ratio;    //  Use the ratio calculated for the voltage divider
                                          //  to calculate the battery voltage
                                          
                                         

  
  batteryPercent = (pinVoltage * ratio)/(9.6)*100;
  
  Serial.print("Pourcentage: ");
  Serial.println(batteryPercent);
  
  if(batteryPercent >= 100)
  {
    digitalWrite(ledBatMonPin,HIGH);
  }
  else if(batteryPercent >= 30)
  {
    digitalWrite(ledBatMonPin,HIGH);
    delay(500);
    digitalWrite(ledBatMonPin,LOW);
    delay(500);
    digitalWrite(ledBatMonPin,HIGH);
    delay(500);
    digitalWrite(ledBatMonPin,LOW);
    delay(500);
    digitalWrite(ledBatMonPin,HIGH);
  }
  else if(batteryPercent >= 10)
  {
    digitalWrite(ledBatMonPin,HIGH);
    delay(500);
    digitalWrite(ledBatMonPin,LOW);
    delay(500);
    digitalWrite(ledBatMonPin,HIGH);
    delay(500);
    digitalWrite(ledBatMonPin,LOW);
    delay(500);
    digitalWrite(ledBatMonPin,HIGH);
    delay(500);
    digitalWrite(ledBatMonPin,LOW);
    delay(500);
    digitalWrite(ledBatMonPin,HIGH);
  }
  
  
}
