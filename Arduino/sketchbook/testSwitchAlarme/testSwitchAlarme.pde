
int ActiveAlarmePin = 12;
int EtatSwitch = 13;

boolean etatAlarme = 0;

void setup() {
  
  pinMode(ActiveAlarmePin, OUTPUT); // set a pin for buzzer output
  pinMode(EtatSwitch,INPUT);

  Serial.begin(9600);
  
}

void loop() {
  
  boolean etatLu;
  
  etatAlarme = 1;
  
  digitalWrite(ActiveAlarmePin,etatAlarme);

  if(etatAlarme)
  {
    Serial.println("Alarme activée");
  }
  else
  {
    Serial.println("Alarme désactivée");
  }
  
  etatLu = digitalRead(EtatSwitch);
  
  if(etatLu)
  {
    Serial.println("Switch fermé");
  }
  else
  {
    Serial.println("Switch ouvert");
  }
  
  delay(5000);
}
