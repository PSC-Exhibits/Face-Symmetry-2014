import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class findCamera extends PApplet {



public void setup() {
  size (1400, 900); 
  background (0); 
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    //cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      if (i < 40 )text(i + " " + cameras[i], 20, 20* i + 50);
      if (i >= 39 && i < 80) text(i + " " + cameras[i], 20 + 400, 20* i + 50 - (20*40));
      else text(i + " " + cameras[i], 20 + 800, 20* i + 50 - (20*80));
      println (i + " " + cameras[i]); 
    }
  }


  text ("Camera Port printer for Face Symmetry 2014", 20, height - 20);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "findCamera" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
