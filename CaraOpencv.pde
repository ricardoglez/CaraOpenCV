import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

String tu = "TU";
String[] quien = { "MAMA", "HERMANA", "NOVIA", "ABUELA"};
            

PFont f;
Capture cap; // Captura de Video
OpenCV caraCV; // Vision computarizada detectora de caraCV
//OpenCV ojos; 
Rectangle[] caras; // Arreglo de la infomracion de la caraCV
//Rectangle[] eyes; 
int[] fondoPixeles;
boolean hayAlguien; // Si  o No
PGraphics fondo, dib; // Lienzo donde se almacena la captura del fondo sin personas

void setup() {
  size(640, 480);
  //Inicializacion de captura, procesos de CV y creación de lienzo
  cap = new Capture(this, width, height);
  cap.start();
  f = loadFont("Courier10PitchBT-Roman-48.vlw");
  caraCV = new OpenCV(this, cap);
  fondo = createGraphics(width, height);
  fondoPixeles = new int[width* height];
  caraCV.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  //Comienza la detección
  caras = caraCV.detect();
  frameRate(5);
}

void draw() {
  background(255);
  //actualizarFondo();
  // Leer y cargar la captura al opencv
  cap.read();
  caraCV.loadImage(cap);
  hayAlguien = startDet(); // comienza el procesos de detección
}

boolean startDet() {
  int x_, y_;
  float angMov;

  caras = caraCV.detect();
  if (caras.length != 0) { //Si detecta alguna caraCV ...
    noFill();
    image(cap, 0, 0);
    stroke(0, 255, 0);
    strokeWeight(1);
    angMov = 45;
    
    for (int i = 0; i < caras.length; i++) { // Dibuja x por cada caraCV ...
      x_ = caras[i].x;
      y_ = caras[i].y;      
      //rect(caras[i].x, caras[i].y, caras[i].width, caras[i].height);
      // println(angMov)
      //pushMatrix();
      //translate(caras[i].x, caras[i].y);
      //y_ = caras[i].width * sin(20);
      dTexto(x_,y_, caras[i].width, caras[i].height, f);

    }
    return true;
  } else { // Si no detecta nada ...
    image(cap, 0, 0);
    return false;
  }
}


void dTexto(int rx, int ry, int rh ,int rw, PFont font){
  textFont(font, 40);
  textMode(CENTER);
  noFill();
  //stroke(0,255,0);
  //rect(rx, ry, rw, rh);

   
  for (int i = 0; i <= quien.length-1; i++) {
    int rand = int(random(0, quien.length-1));
    float sca = map(rw,0,height-200, 0.8, 2);   
    float sep = random(0,6)* map(rh,0,400, 1, 10);
    fill(0);
    //QUIEN    
     // Izquierda
    //TU
    pushMatrix();
    translate(rx-220, ry+70);
    //scale(sca);
    textFont(font, 50);
    text(tu, -10, -30 * i);
    text(quien[rand], 70, -60 * i);
    popMatrix();
    

    pushMatrix();
    translate(rx, ry+30);
    //scale(sca);
    textFont(font, 60);    
    text(quien[rand], rw +30, -60 *i);
    popMatrix();
    
    //TU  + QUIEN
    pushMatrix();
    fill(0,0,0,60);
    translate(rx, ry);
//    scale(sca);
    textFont(font, 50);
    text(tu, -10, -30);
    text(quien[rand], 70, -30);
    popMatrix();
  } 
  
}

void actualizarFondo() {
  // println("Actualizado");
  cap.loadPixels();
  arraycopy(cap.pixels, fondoPixeles);
  fondo.beginDraw();
  //Iteracion de colocación de pixeles
  for (int i = 0; i <= cap.pixels.length-1; i++) {
    cap.pixels[i] = fondoPixeles[i];
  }
  fondo.endDraw();
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    println("A presionada");
    actualizarFondo();
  }
}