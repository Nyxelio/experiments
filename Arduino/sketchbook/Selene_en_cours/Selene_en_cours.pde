// Selene. 
// Gestion des alarmes 
// Note: code du transpondeur: 010B27AADB

#include <NewSoftSerial.h>

int RxRFID = 10;
int TxRFID = 11;
int LEDJAUNERFID = 8;
int LEDROUGEALARME = 7;
int BUZZER = 9;
int CMDALARME = 12;
int ETATSWITCH = 13;

NewSoftSerial rfidSerial(RxRFID, TxRFID); // (RX, TX)

//transpondeur de référence
byte refTag[] = {0x01,0x0B,0x27,0xAA,0xDB};

boolean etatAlarme = 0;
boolean etatSwitchLu;
boolean alarmeDeclenchee = 0;
  
void setup() {
  
  pinMode(BUZZER, OUTPUT); // set a pin for buzzer output
  pinMode(LEDJAUNERFID, OUTPUT);
  pinMode(LEDROUGEALARME, OUTPUT);
  pinMode(CMDALARME, OUTPUT); 
  pinMode(ETATSWITCH, INPUT);

  Serial.begin(9600);
  
  // set the data rate for the NewSoftSerial port
  rfidSerial.begin(9600); // communication speed of UM-005
  
}

void loop() {
  
  //buzzOK(); //acquittement tache
  
  //buzzAlarme(10); //10 seconds
 
 //ledAlarme(HIGH); //Mise sous tension led alarme(jaune, fixe)
 
  //delay(1000); // wait a bit between buzzes
  
  //ledOK();

  //delay(1000);
  
  int res;
 
  //----RFID------
  //activation / désactivation alarme
  res = getRFID();
  
  if(res)
  {
    
    //Serial.println("passe rfid");
    //keychain lu et conforme
    //active / désactive
    
    //jaune
    ledRfidOK();
    //buzzOK(); //acquittement tache
    
    if(etatAlarme)
    {
       etatAlarme = 0;
       
       desactiveAlarme();
    }
    else
    {
        etatAlarme = 1;
        
        activeAlarme();
    }
    
  }
  else if(res == -1)
  {
    //erreur sur keychain
    //signalement
      //Serial.print("Erreur !");
    //+led
    
    
    ledFailed();
  }
  //!
  
  //---Etat-des-portes---
  //vérification état alarme et déclenchement
  etatSwitchLu = digitalRead(ETATSWITCH);
  
  if(etatAlarme)
  {
    if(etatSwitchLu && alarmeDeclenchee)
    {
       // Serial.println("Switch fermé");
       
       //Signifie que l'alarme a été déclenchée mais
       //tout les switchs sont désormais fermés
       
       Serial.print("3");
       
       alarmeDeclenchee = 0;
    }
    //else
    if(!etatSwitchLu)
    {
      //Serial.println("Switch ouvert");
      
      //Déclenchement alarme
      //et autres actions
      
      declencheAlarme();
      
      alarmeDeclenchee = 1;
   
    }
  }
  //!
  
}

void ledRfidOK()
{
  digitalWrite(LEDJAUNERFID,HIGH);
  delay(500);
  digitalWrite(LEDJAUNERFID,LOW);
  delay(500);
  digitalWrite(LEDJAUNERFID,HIGH);
  delay(500);
  digitalWrite(LEDJAUNERFID,LOW);
}


void ledFailed()
{
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  digitalWrite(LEDJAUNERFID,HIGH);
  delay(200);
  digitalWrite(LEDJAUNERFID,LOW);
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  digitalWrite(LEDJAUNERFID,HIGH);
  delay(200);
  digitalWrite(LEDJAUNERFID,LOW);
  delay(200);
}


void ledDeclencheAlarme()
{
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  delay(200);
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  delay(200);
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  delay(200);
  digitalWrite(LEDROUGEALARME,HIGH);
  delay(200);
  digitalWrite(LEDROUGEALARME,LOW);
  delay(200);
  digitalWrite(LEDROUGEALARME,HIGH);
}

void ledAlarme(int state)
{
   digitalWrite(LEDROUGEALARME,state); 
}

void buzzOK() {
    buzz(BUZZER, 4800, 200); // buzz the buzzer on pin 4 at 2500Hz for 1000 milliseconds
    delay(50); // wait for the calculated delay value
    buzz(BUZZER, 4800, 200); // buzz the buzzer on pin 4 at 2500Hz for 1000 milliseconds
}

void buzzAlarme(int length) {
 
 for (long i=0; i < length; i++){ 
    buzz(BUZZER, 2500, 1000); // buzz the buzzer on pin 4 at 2500Hz for 1000 milliseconds
    buzz(BUZZER, 3200, 200); // buzz the buzzer on pin 4 at 2500Hz for 1000 milliseconds
 }
}

void buzz(int targetPin, long frequency, long length) {
  long delayValue = 1000000/frequency/2; // calculate the delay value between transitions
  //// 1 second's worth of microseconds, divided by the frequency, then split in half since
  //// there are two phases to each cycle
  long numCycles = frequency * length/ 1000; // calculate the number of cycles for proper timing
  //// multiply frequency, which is really cycles per second, by the number of seconds to 
  //// get the total number of cycles to produce
 for (long i=0; i < numCycles; i++){ // for the calculated length of time...
    digitalWrite(targetPin,HIGH); // write the buzzer pin high to push out the diaphram
    delayMicroseconds(delayValue); // wait for the calculated delay value
    digitalWrite(targetPin,LOW); // write the buzzer pin low to pull back the diaphram
    delayMicroseconds(delayValue); // wait againf or the calculated delay value
  }
}


//Si rien a lire, retourne 0,
//Si keychain lu différent celui enregistré, retourne -1
//Si keychain lu égal celui enregitré, retourne 1.
int getRFID(){
 
  byte i = 0;
  byte val;
  byte code[5];
  byte rfidRead[10];
  byte bytesread = 0;
  int result = 0;
 
  if(rfidSerial.available()) {
   
   //Le premier caractere de la trame est toujours 1 
    if(rfidSerial.read() == 0x01) { 
      bytesread = 0; 
    
      //Serial.println("I read it");
      
      while (bytesread < 10) {// read 5 bytes digit code + 1 byte oper code + 2 bytes digit checksum
        if(rfidSerial.available()) {
         
         rfidRead[bytesread] = rfidSerial.read();
         
          bytesread++; // ready to read next digit
        } 
      } 


      if (bytesread == 10) {  // if 10 digit read is complete
      
        for (i=2; i<7; i++) {
          
          code[i-2] = rfidRead[i]; 
        
          /* //Activer pour affichage du code
          Serial.println();
          Serial.print("5-byte code: ");  
          if (code[i] < 16) Serial.print("0");
          Serial.print(code[i], HEX);
          Serial.print(" ");
         */

        }
        
         if(checkTwo(code,refTag))
         {
           //Serial.print("Acces autorise");
           
           result = 1;
         }
        else
         {
           result = -1;
         } 
        
        delay(3000);
        rfidSerial.flush();
      }
      
      bytesread = 0;
    }
  }
  
  return result;
}

// Check two arrays of bytes to see if they are exact matches
boolean checkTwo ( byte a[], byte b[] )
{
  boolean match = false;
  
  if ( a[0] != NULL )             // Make sure there is something in the array first
    match = true;                 // Assume they match at first
    
  for ( int k = 0;  k < 5; k++ )  // Loop 5 times
  {
    
    /*Serial.print("[");
    Serial.print(k);
    Serial.print("] ReadCard [");
    Serial.print(a[k], HEX);
    Serial.print("] StoredCard [");
    Serial.print(b[k], HEX);
    Serial.print("] \n");*/
    
    
    if ( a[k] != b[k] )           // IF a != b then set match = false, one fails, all fail
     match = false;
  }
  if ( match )                    // Check to see if if match is still true
  {
    //Serial.print("Strings Match! \n");  
    return true;                  // Return true
  }
  else {
    //Serial.print("Strings do not match \n"); 
    return false;                 // Return false
  }
}


void desactiveAlarme()
{
       digitalWrite(CMDALARME,LOW);
       
       //TMP
      //Serial.print("Desactive alarme");
     
      //statut code
      Serial.print("1");
     
      ledAlarme(LOW);
}


void activeAlarme()
{
      //TMP
      //Serial.print("Active alarme");
      
      //statut code
      Serial.print("0");
      
       //attente 20 secondes(fermeture porte principale)
      //Mise sous tension alarme
      delay(10000);
     
    
       
      digitalWrite(CMDALARME,HIGH);
      
      //+buzzer
      //+led OK
      
      
      //ledalarme
     
      ledAlarme(HIGH); //Mise sous tension led alarme(rouge, fixe)
}

void declencheAlarme()
{
  
  //attente de 20 secondes pour couper l'alarme lors de l'entrée
  delay(10000);
  
  Serial.print("2");
  
  ledDeclencheAlarme();
  buzzAlarme(10);
}
