/* Face Symmetry Aduino Code. Made for Arduino UNO 
 Pacific Science Center 2014. */

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
    if (digitalRead(sw0) == HIGH) Serial.print (0);
    if (digitalRead(sw1) == HIGH) Serial.print (1);
    if (digitalRead(sw2) == HIGH) Serial.print (2);
    if (digitalRead(sw3) == HIGH) Serial.print (3);
    if (digitalRead(sw4) == HIGH) Serial.print (4);
    if (digitalRead(sw5) == HIGH) Serial.print (5); 
    delay(100); 
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send a capital A
    delay(300);
  }
}


