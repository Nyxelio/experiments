//Tri-color led fading

int RED = 11;    // RED pin of the LED to PWM pin 37
int GREEN = 10;  // GREEN pin of the LED to PWM pin 36
int BLUE = 9;   // BLUE pin of the LED to PWM pin 35

void setup()
{
  pinMode(9, OUTPUT); 
  pinMode(10, OUTPUT); 
  pinMode(11, OUTPUT); 
}

void loop()
{
  for(int r = 0; r < 1024; r+=5) {
    for(int g = 0; g < 1024; g+=5) {
      for(int b = 0; b < 1024; b+=5) {
        analogWrite(RED, r);
        analogWrite(GREEN, g);
        analogWrite(BLUE, b);
        delay(30);
      }
    }
  }
}
