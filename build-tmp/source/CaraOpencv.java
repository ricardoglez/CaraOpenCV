import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import java.awt.Rectangle; 
import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CaraOpencv extends PApplet {





Capture cap; // Captura de Video
OpenCV cara; // Vision computarizada detectora de cara
//OpenCV ojos; 
Rectangle[] faces; // Arreglo de la infomracion de la cara
//Rectangle[] eyes; 
int[] fondo_;
boolean hayAlguien; // Si  o No
PGraphics fondo, dib; // Lienzo donde se almacena la captura del fondo sin personas
//PImage f, d;

public void setup() {
  size(640, 480);
  //Inicializacion de captura, procesos de CV y creaci\u00f3n de lienzo
  cap = new Capture(this, width, height);
  cap.start();
  cara = new OpenCV(this, cap);
  fondo = createGraphics(width, height);
  fondo = createGraphics(width, height);
  cara.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  //Comienza la detecci\u00f3n
  faces = cara.detect();
}

public void draw() {
  background(255);
  actualizarFondo();
  // Leer y cargar la captura al opencv
  cap.read();
  cara.loadImage(cap);
  hayAlguien = startDet(); // comienza el procesos de detecci\u00f3n  
}

public boolean startDet(){
  
  faces = cara.detect();
  if (faces.length != 0) { //Si detecta alguna cara ...
    noFill();
    stroke(0, 255, 0);
    strokeWeight(1);
    for (int i = 0; i < faces.length; i++) { // Dibuja la zona de las caras y detecta los ojos...
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    return true;
  } else { // Si no detecta nada ...
    image(fondo,0,0);
    return false;
  }
}

public void actualizarFondo(){
    cap.loadPixels();
    //arraycopy(cap.pixels , fondo_);
    fondo.beginDraw();
    //Iteracion de colocaci\u00f3n de pixeles
    for(int i = 0 ; i < cap.pixels.length; i++){
      fondo.pixels[i] = fondo_[i];
    }
    fondo.endDraw();
 }

public void keyPressed() {
  if (key == 'a' || key == 'A') {
    actualizarFondo();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CaraOpencv" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
