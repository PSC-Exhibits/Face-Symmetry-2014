import processing.serial.*;

size (300, 300); 
background (0); 

for (int i = 0; i < Serial.list().length; i++) {
  text (i + " " + Serial.list()[i], 20, 20 * i + 50);
  println (i+ " " + Serial.list()[i]);
}

text ("Serial Port printer for Face Symmetry 2014", 20, height - 20); 

