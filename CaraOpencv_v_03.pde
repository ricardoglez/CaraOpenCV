import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*; 
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;

String tu = "TU";
String[] quien = { "MAMA", "HERMANA", "NOVIA", "ABUELA"};
PImage imgF;
PFont f;
Capture cap; // Captura de Video
OpenCV caraCV; // VispenCVion computarizada detectora de caraCV
OpenCV contornos;
ArrayList<Contour> contours;

Rectangle[] caras; // Arreglo de la infomracion de la caraCV
//Rectangle[] eyes; 
int[] fondoPixeles; // Pixeles del fondo Fijo
boolean hayAlguien; // Si  o No
PGraphics fondo, dib; // Lienzo donde se almacena la captura del fondo sin personas

void setup() {
  size(1280, 720);
  //println(Capture.list());
  //Inicializacion de captura, procesos de CV y creación de lienzo
  cap = new Capture(this, width, height);
  cap.start();
  f = loadFont("Courier10PitchBT-Roman-48.vlw");
  imgF = loadImage("fondo.jpg");
  caraCV = new OpenCV(this, cap);
  contornos = new OpenCV(this, cap);
  contornos.gray();
  contornos.threshold(89);
  contornos.startBackgroundSubtraction(20, 10, .02);
  fondo = createGraphics(width, height);
  fondoPixeles = new int[width* height];
  fondo.beginDraw();
  fondo.image(imgF, 0, 0);
  fondo.endDraw();
  caraCV.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  //Comienza la detección
  caras = caraCV.detect();
  //frameRate(6);
}

void draw() {
  pushMatrix();
  translate(1319, -799);
  rotate(HALF_PI);
  scale(2.0);
  //background(255);

  //actualizarFondo();
  // Leer y cargar la captura al opencv
  //image(fondo,0,0);
  cap.read();
  caraCV.loadImage(cap);

  contornos.loadImage(cap);
  contornos.threshold(80);
  contornos.updateBackground();
  contornos.dilate();
  contornos.erode();
  contours = contornos.findContours();
  //fill(50,50,50,100);
  stroke(0);
  noFill();
  startDet(); // comienza el procesos de detección
  noFill();
  strokeWeight(1);
  dib.beginDraw();
  for (Contour contour : contours) {
    dib.add(contour.draw());
  }
  dib.endDraw();
  popMatrix();
}


boolean startDet() {
  int x_, y_;
  caras = caraCV.detect();
  if (caras.length != 0) { //Si detecta alguna caraCV ..
    noFill();
    background(255);
    
    pushMatrix();
    translate(-114, -60);
    scale(1.0);
    image(fondo, 0, 0);
    popMatrix();
    //stroke(0, 255, 0);
    strokeWeight(.5);
    for (int i = 0; i < caras.length; i++) { // Dibuja x por cada caraCV ...
      x_ = caras[i].x; // ubicacion del rostro x
      y_ = caras[i].y; // ubicacion del rostro y     
      // Dibujar el texto como matriz, necesita la ubicacion, el tamaño del rostro y la fuente que usara el texto
      dTextoFull(x_, y_, caras[i].width, caras[i].height, f);
    }
    return true;
  } else { // Si no detecta nada ...

    //actualizarFondo();
    // Dibujar el fondo sin personas
    translate(-114, -60);
    pushMatrix();
    scale(1.0);
    image(fondo, 0, 0);
    popMatrix();
    //background(255,255,255,100);
    //text("NARIZ DE PERRO GRIS", width / 2 , height / 2);
    return false;
  }
}

void dTextoFull(int rx, int ry, int rh, int rw, PFont font) {
  int wText =   rw /2;
  int hText  = rh /4;
  int wBT = wText; 
  int hBT = hText ;
  //textMode(CENTER);
  //fill(0,255,0);
  //Dibujar el rectangulo de la cara detectada
  //stroke(0,255,0);
  //rect(rx, ry, rw, rh);
  //Por cada rectangulo que encuentre
  int palabra = int (random(0, 3));
  for (int i = 0; i <= quien.length-1; i++) {

    //fill(0);
    //Dibujar la matrix de palabras
    for (int ubicaX = 0; ubicaX <= width; ubicaX += wText  ) {
      for (int ubicaY = 0; ubicaY <= height; ubicaY += hText ) {    
        if (!(ubicaX >= rx - wText && ubicaY >= ry - hText ) || !(ubicaX <= ( rx + rw )  && ubicaY <= ( ry + rh + hText )) ) {
          fill(0);
          textFont(font, hText / 3  );
          text(tu + " " + quien[palabra], ubicaX, ubicaY, wBT, hText);
        } else {
          // Nariz de codorniz
          //noFill();
          //rect(ubicaX, ubicaY, wText, hText);
        }
      }
    }
  }
}

void actualizarFondo() {
  println("Actualizado");
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
    actualizarFondo();
  }
}