/*
  test potentiometre
 */

int potpin = A0;
int val;

void setup() {
  Serial.begin(9600);
}

void loop() {
  //int val = analogRead(potpin);
  
  //val = map(val, 0, 1023, 0, 225);
  
  //Serial.println(val, DEC);

  //analogWrite(3,val);
  
   analogWrite(3,255);
  
  delay(15);

   //analogWrite(3,0);
  
  //delay(1000);
  
}
