//XBEE Experiment
 
void setup(){

  Serial.begin(9600);
}
 
void loop(){
 
  String str;

  delay(5000);
  
  if(Serial.available())
  {
    str = Serial.read();
    
    digitalWrite(13,HIGH);
    delay(2000);
    digitalWrite(13,LOW);
    
    Serial.println("Response:"+str);
  }
      
}
