// Buzzer experiment for the CEM-1203 buzzer (Sparkfun's part #COM-07950).


//referenced from http://www.phy.mtu.edu/~suits/notefreqs.html
//starting with F noteFreqArr[0]
int noteFreqArr[] = {
49.4, 52.3, 55.4, 58.7, 62.2, 65.9, 69.9, 74, 78.4, 83.1, 88, 93.2, 
98.8, 105, 111, 117, 124, 132, 140, 148, 157, 166, 176, 186, 
198, 209, 222, 235, 249, 264, 279, 296, 314, 332, 352, 373, 
395, 419, 444, 470, 498, 527, 559, 592, 627, 665, 704, 746, 
790, 837, 887, 940, 996, 1050, 1110, 1180, 1250, 1320, 1400, 1490, 
1580, 1670, 1770, 1870, 1990, 2100};

void setup() {
    pinMode(4, OUTPUT); // set a pin for buzzer output
}

void playNote(int noteInt, long length, long breath = 0) {
    length = length - breath;
    buzz(4, noteFreqArr[noteInt], length);
    if(breath > 0) { //take a short pause or 'breath' if specified
        delay(breath);
    }
}

void loop() {
  /*  playNote(52, 1000);
    playNote(53, 1000);
    playNote(54, 1000);
    playNote(55, 1000, 100);
    playNote(56, 1000);
    playNote(57, 1000);
    playNote(58, 1000);
    playNote(59, 1000, 100);
    playNote(60, 1000);
    playNote(61, 1000);
    playNote(62, 1000);
    playNote(63, 1000, 100);
    */
    
    playNote(56, 500);
    playNote(56, 500);
    playNote(58, 700);
    playNote(56, 700);
    playNote(60, 700);
    playNote(58, 900);
    
    playNote(56, 500);
    playNote(56, 500);
    playNote(58, 700);
    playNote(56, 700);
    playNote(62, 700);
    playNote(60, 900);
    
    
    delay(1000); // wait a bit between buzzes
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

