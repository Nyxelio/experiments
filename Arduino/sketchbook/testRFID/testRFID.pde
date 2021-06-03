//Test XBEE
 
void setup(){

  Serial.begin(9600);
}
 
void loop(){
 
  String str;
  
  Serial.println("Test d'écriture à partir de xbee shield");
  
  delay(5000);
  
  if(Serial.available())
  {
    str = Serial.read();
    
    digitalWrite(13,HIGH);
    delay(2000);
    digitalWrite(13,LOW);
    
    Serial.println("Bien reçu:"+str);
  }
      
}
