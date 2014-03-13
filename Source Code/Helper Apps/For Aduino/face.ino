/* Face Symmetry Aduino Code. Made for Arduino UNO 
Pacific Science Center 2014. Lia Martinez */

#define sw0 7 
#define sw1 6 
#define sw2 5 
#define sw3 4 
#define sw4 3 
#define sw5 2 

void setup() {
  Serial.begin (9600); 
  pinMode (sw0, INPUT); 
  pinMode (sw1, INPUT); 
  pinMode (sw2, INPUT); 
  pinMode (sw3, INPUT); 
  pinMode (sw4, INPUT); 
  pinMode (sw5, INPUT); 
  establishContact();  // send a byte to establish contact until Processing responds 
}

void loop () {
  if (Serial.available() > 0) {
    Serial.print (digitalRead(sw0), DEC);
    Serial.print (digitalRead(sw1), DEC);
    Serial.print (digitalRead(sw2), DEC);
    Serial.print (digitalRead(sw3), DEC);
    Serial.print (digitalRead(sw4), DEC);
    Serial.print (digitalRead(sw5), DEC);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send a capital A
    delay(300);
  }
}

