/*
  RC car experiment
 */
int left = 8;       // left pin
int right = 9;       // right pin
int forward = 10;    // forward pin
int reverse = 11;    // reverse pin

int batMonPin = 0;    // input pin for the divider
int ledBatMonPin = 13;
int val = 0;       // variable for the A/D value
float pinVoltage = 0; // variable to hold the calculated voltage
//float batteryVoltage = 0;
float batteryPercent = 0;
float ratio = 4.68;

// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pins as an outputs:
  pinMode(forward, OUTPUT);
  pinMode(reverse, OUTPUT);
  pinMode(left, OUTPUT);
  pinMode(right, OUTPUT);
  
  pinMode(ledBatMonPin,OUTPUT);
  
  Serial.begin(9600);      // open the serial port at 9600 baud
  
  
}

void go_forward()
{
  digitalWrite(forward,HIGH);   // turn forward motor on
  digitalWrite(reverse,LOW);    // turn revers motor off
}

void go_reverse()
{
  digitalWrite(reverse,HIGH);    // turn reverse motor on
  digitalWrite(forward,LOW);    // turn forward notor off
}

void stop_car()
{
  digitalWrite(reverse,LOW);     // turn revers motor off
  digitalWrite(forward,LOW);    // turn forward motor off
  digitalWrite(left,LOW);
  digitalWrite(right,LOW);
}

void go_left()
{
  digitalWrite(left,HIGH);     // turn left motor on
  digitalWrite(right,LOW);
}

void go_right()
{
  digitalWrite(left,LOW);     // turn left motor on
  digitalWrite(right,HIGH);
}


void loop() 
{
   
  batteryMonitor();
  
  
  go_forward();
  delay(500);
  
  go_reverse();
  delay(500);
  
  
  go_left();
  delay(200);
  
  go_right();
  delay(200);
  
  stop_car();
  delay(500);
  
  //go_forward();
  //delay(1000);
  //go_left();
  //delay(3000);
  //go_forward();
  //delay(1000);
  //go_right();
  //delay(3000);
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
  
  Serial.print("Percent: ");
  Serial.println(batteryPercent);
  
  if(batteryPercent > 30)
  {
    digitalWrite(ledBatMonPin,HIGH);
  }
  else if((batteryPercent <= 30) && (batteryPercent > 10))
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
  else if((batteryPercent <= 10) && (batteryPercent > 2))
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
  else
  {
    digitalWrite(ledBatMonPin,LOW);
  }
  
  
}  


  
 
