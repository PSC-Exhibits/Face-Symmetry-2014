import processing.video.*;

void setup() {
  size (500, 800); 
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
      text(i + " " + cameras[i], 20, 20* i + 50);
    }
  }


  text ("Camera Port printer for Face Symmetry 2014", 20, height - 20);
}

