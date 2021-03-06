//Test RFID
//code du transpondeur: 010B27AADB

#include <NewSoftSerial.h>

int RxRFID = 10;
int TxRFID = 11;

//using pin ^
NewSoftSerial rfidSerial(RxRFID, TxRFID); // (RX, TX)

//transpondeur de référence
byte refTag[] = {0x01,0x0B,0x27,0xAA,0xDB};
 
void setup(){

  Serial.begin(9600);
  
  // set the data rate for the NewSoftSerial port
  rfidSerial.begin(9600); // communication speed of UM-005
}

void loop()
{
  int res;
 
  res = getRFID();
  
  if(res)
  {
    //keychain lu et conforme
    //active / désactive
    
    Serial.print("Active/désactive");
    
    //+buzzer
    //+led
  }
  else if(res == -1)
  {
    //erreur sur keychain
    //signalement
    
    //+led
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
