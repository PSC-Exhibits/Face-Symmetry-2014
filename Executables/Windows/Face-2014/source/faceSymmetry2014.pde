import processing.video.*;
import processing.serial.*;
Serial myPort; 

PImage pic, mirror, left, right;  
PImage title; 
String titlePic; 

int w, h; 

//save these to a CSV
float scale, frameHeight; 

boolean newPic; 

Capture cam; 
int activeCam; 

String [] switches = new String[6];
int serialCount = 0; 
boolean firstContact = false; 

int serialPort;
boolean goSwitch;
int state = 6; 

//timers
int startCycleTime; 
int waitInterval; 
int displayInterval = 3000; 
boolean firstSession = true;
boolean newSession = true; 
boolean goCycle = false; 
boolean newPin = false; 
int activePin = -1; 

void setup() { 



  String[] config = loadStrings ("config.csv"); 
  if (config.length < 1) {
    println ("Error. No config file found. loading defaults.");   
    scale = 2.0; 
    frameHeight = w/2;
    activeCam = 0; 
    serialPort = 0; 
    titlePic = "title.jpg"; 
    waitInterval = 20000; 
    displayInterval = 3000;
    w = 1280; 
    h = 720;
  } 
  else {
    println ("Loading config.csv file ..."); 
    String[] s = new String [2]; 
    String[] hh = new String [2]; 
    String[] a = new String [2];
    String[] sp = new String [2]; 
    String[] t = new String [2];
    String[] wa = new String [2];
    String[] d = new String [2];
    String[] wi = new String [2];
    String[] he = new String [2];


    for (int i = 0; i < config.length; i++) {
      s = split (config[0], ","); 
      hh = split (config[1], ","); 
      a = split (config[2], ",");
      sp = split (config[3], ",");   
      t = split (config[4], ",");
      wa = split (config[5], ","); 
      d = split (config[6], ",");
      wi = split (config[7], ","); 
      he = split (config[8], ",");
    }
    scale = float(s[1]); 
    frameHeight = float(hh[1]);
    activeCam = int (a[1]); 
    serialPort = int (sp[1]); 
    titlePic = t[1]; 
    waitInterval = int(wa[1]); 
    displayInterval = int(d[1]);
    w = int(wi[1]);
    h = int(he[1]);
  }


  size (displayWidth, displayHeight); 

  title = loadImage (titlePic); 

  pic = createImage (w, h, RGB);
  mirror = createImage (w, h, RGB); 
  left = createImage (w, h, RGB); 
  right = createImage (w, h, RGB); 

  pic.loadPixels(); 
  mirror.loadPixels(); 
  left.loadPixels(); 
  right.loadPixels(); 

  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[serialPort], 9600);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, w, h);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }

    cam = new Capture(this, cameras[activeCam]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    cam.start();
  }

  newPic = true;
  startCycleTime = millis();
}

void draw() {
  background (0); 

  loadPixels(); 

  if (cam.available()) {
    cam.read(); 
    cam.loadPixels();
  }

  pushMatrix(); 
  translate (displayWidth/2, displayHeight/2); 
  scale (scale); 
  pushMatrix(); 
  translate (-frameHeight, -h/2); 
  switch (state) {

  case 0: 
    //camera
    pushMatrix(); 
    scale (-1, 1); 
    image (cam, -w, 0); 
    popMatrix(); 

    stroke (200, 0, 0); 
    strokeWeight(4); 
    line (0, cam.height/2, cam.width, cam.height/2); 

    newPic = true; 
    break;

  case 1:
    //take picture 
    if (newPic) {
      takePic();
      if (firstSession) firstSession = false; 
      newPic = false;
    }

    float s = .50;
    pushMatrix(); 
    scale (s); 
    image (pic, 0, 0); 
    image (mirror, mirror.width, 0); 
    image (left, 0, left.height); 
    image (right, right.width, right.height); 
    popMatrix(); 
    break;  

  case 2: 
    image (mirror, 0, 0); 
    break; 

  case 3:
    image (pic, 0, 0); 
    break; 

  case 4:
    image (left, 0, 0); 
    break; 

  case 5:
    image (right, 0, 0); 
    break;

  case 6: 
    image (title, 0, 0, w, h);
  }

  popMatrix(); 
  popMatrix();

  if (newPin) {
    if (firstSession) {
      if (activePin == 1) state = 1; 
      else state = 0;
    } 
    else { 
      state = activePin;
    }   
    startCycleTime = millis();
    goCycle = false; //stop cycling when a switch is touched
    newPin = false;
  }

  if (goSwitch) {
    if (state < 6) state ++; 
    else state = 1;       
    goSwitch = false;
  } 

  //Enable cycling after waitInterval expires
  if (millis() - startCycleTime > waitInterval) {
    newSession = true; 
    if (firstSession) {
      state = 6;
    } 
    else { //only do this if the title has already been displayed and its not the first session of the day
      goCycle = true;
    }
  }

  if (goCycle) { 
    activePin = -1; 
    if (newSession) { //start by displaying the title
      state = 6; 
      startCycleTime = millis(); 
      newSession = false;
    } 
    else { //then just cycle as necessary
      if (millis() - startCycleTime > displayInterval) {
        goSwitch = true; 
        startCycleTime = millis();
      }
    }
  }
}

void serialEvent (Serial myPort) {
  String input = myPort.readString(); 


  if (firstContact == false) {
    if (input.equals("A")) { 
      println ("I see the arduino!"); 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  } 
  else {
    int intSw = int(input); 
    if (state != intSw) {
      activePin = intSw; 
      newPin = true;
       myPort.write('A');
    }
  }
}


void mirror() {
  for (int y = 0; y < cam.height; y++) {
    for (int x = 0; x < cam.width; x++) {
      int loc = x + y * w; 
      int revLoc = x +(h-1 - y)*cam.width; 
      mirror.pixels[revLoc] = cam.pixels[loc];
    }
  }
  mirror.updatePixels();
}

void leftSide() {
  for (int y = 0; y < cam.height/2; y++) {
    for (int x = 0; x < cam.width; x++) {
      int loc = x+y*cam.width; 
      int rightLoc = x +(h-1 - y)*cam.width; 
      left.pixels[loc] = cam.pixels[loc];
      left.pixels[rightLoc] = cam.pixels[loc];
    }
  }
  left.updatePixels();
}

void rightSide() {
  for (int y = cam.height/2; y < cam.height; y++) {
    for (int x = 0; x < cam.width; x++) {
      int loc = x+y*cam.width; 
      int left = x +(h-1 - y)*cam.width;
      right.pixels[loc] = cam.pixels[loc];
      right.pixels[left] = cam.pixels[loc];
    }
  }
  right.updatePixels();
}

void saveFile() {
  println ("Settings saved to data/config.csv"); 
  String [] data = {
    "scale," + str(scale), 
    "height," + str(frameHeight), 
    "active camera (run camera app to get number)," + str(activeCam), 
    "serial port (run serial app to get number)," + str(serialPort), 
    "title picture name," + titlePic, 
    "milliseconds to wait before screensaver," + str(waitInterval), 
    "milliseconds to wait between images," + str(displayInterval), 
    "camWidth," + str(w), 
    "camHeight," + str(h),
  }; 
  saveStrings ("data/config.csv", data);
}


void keyPressed() {
  if (key == '0') {
    state = 0; 
    newPic = true;
  }
  if (key == '1') {
    if (newPic) {
      takePic();
      newPic = false;
    }
    state = 1;
  }
  if (key == '2') state = 2; 
  if (key == '3') state = 3;
  if (key == '4') state = 4;
  if (key == '5') state = 5;

  if (key == 's' || key == 'S') saveFile(); 

  if (key == CODED) {
    if (keyCode == LEFT) scale -= .10; 
    if (keyCode == RIGHT) scale += .10; 
    if (keyCode == UP) frameHeight +=10; 
    if (keyCode == DOWN) frameHeight -=10;
  }
}


void takePic() {
  for (int i = 0; i < cam.pixels.length; i++) {
    pic.pixels[i] = cam.pixels[i];
  }
  pic.updatePixels();

  mirror(); 
  leftSide(); 
  rightSide();
}

