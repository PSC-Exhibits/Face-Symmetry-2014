import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class findSerial extends PApplet {
  public void setup() {


size (300, 300); 
background (0); 

for (int i = 0; i < Serial.list().length; i++) {
  text (i + " " + Serial.list()[i], 20, 20 * i + 50);
  println (i+ " " + Serial.list()[i]);
}

text ("Serial Port printer for Face Symmetry 2014", 20, height - 20); 

    noLoop();
  }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "findSerial" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
