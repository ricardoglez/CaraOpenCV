import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
String tu = "TU";
String[] quien = { "MAMA", "HERMANA", "NOVIA", "ABUELA"};
PImage imgF;
PFont f;
Capture captura; // Captura de Video
OpenCV caraCV; // Vision computarizada detectora de caraCV
OpenCV contornos; // Detectora de contornos
ArrayList<Contour> contours; // Arreglo variable del numero de contornos
Rectangle[] caras; // Arreglo de la infomracion de la caraCV
//Rectangle[] eyes;
int[] fondoPixeles; // Pixeles del fondo Fijo
boolean hayAlguien; // Si  o No
PGraphics fondoC, dib; // Lienzo donde se almacena la captura del fondo sin personas
/*//////////////////////////////////////////7
INICIALIZACION DE VARIABLES Y PROCESOS BASE
*/////////////////////////////////////////////

void setup() {
  size(1280, 720);
  //println(Capture.list());
  //Inicializacion de captura, procesos de CV y creación de lienzo
  fondoPixeles = new int[width * height];
  captura = new Capture(this, width, height);
  captura.start();
  hayAlguien = false;
  f = loadFont("Courier10PitchBT-Roman-48.vlw");
  imgF = loadImage("fondo.jpg");
  caraCV = new OpenCV(this, captura);
  caraCV.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  contornos = new OpenCV(this, captura);
  contornos.gray();
  contornos.threshold(89);
  contornos.startBackgroundSubtraction(20, 10, .02);
  fondoC = createGraphics(width, height);
  dib = createGraphics(width, height);
  //caras = caraCV.detect();
  //frameRate(6);
}
/*/////////////////////7
LOOP INICIAL
*////////////////////////

void draw() {
  pushMatrix();
  //translate(1319, -799);
  //rotate(HALF_PI);
  //scale(2.0);
  //background(255);
  //fill(50,50,50,100);
  stroke(0);
  noFill();
  dibujarFondo();
  preprocessings();
  // comienza el procesos de detección
  if (startDet()) {
    tint(250,250,250,100);
    dibujarFondo();
    //dibujarContornos(.5);
    //image(dib,0,0);
  }
  popMatrix();
}

/*
Aqui se cargan las imagenes y se preprocesan para la vision computarizada
*/
void preprocessings(){
  // Leer y cargar la captura al opencv
  captura.read();
  caraCV.loadImage(captura);
  contornos.loadImage(captura);
  contornos.threshold(60);
  contornos.updateBackground();
  contornos.dilate();
  contornos.erode();
  contours = contornos.findContours();

}
/*
Dibujar COntornos encontrados
*/
void dibujarContornos( float size) {
  translate(0, 0);
  pushMatrix();
  //scale(3.0);
  strokeWeight(size);
  for (Contour contour : contours) {
    contour.draw();
  }
  popMatrix();
}
/*
Detecta si hay alguna cara en la escena
*/

boolean startDet() {
  int x_, y_;
  caras = caraCV.detect();
  if (caras.length != 0) { //Si detecta alguna caraCV ..
    hayAlguien = true;
    for (int i = 0; i < caras.length; i++) { // Dibuja x por cada caraCV ...
      //dibujarFondo();
      x_ = caras[i].x; // ubicacion del rostro x
      y_ = caras[i].y; // ubicacion del rostro y
      // Dibujar el texto como matriz, necesita la ubicacion, el tamaño del rostro y la fuente que usara el text
      dTextoFull(x_, y_, caras[i].width, caras[i].height, f);
      dibujarContornos(.5);
    }
  } else { // Si no detecta nada ...
    // Dibujar el fondo Fijo
    dib.beginDraw();
      dib.background(0, 0 );
    dib.endDraw();
    hayAlguien= false;
    dibujarFondo();
  }
  return hayAlguien;
}

void dibujarFondo() {
  fondoC.beginDraw();
      fondoC.background(0,0);
      fondoC.image(imgF, 0, 0);
  fondoC.endDraw();
  image(fondoC, 0, 0);
}
/*
Dibujar la matriz de texto al rededor de las caras
*/
void dTextoFull(int rx, int ry, int rh, int rw, PFont font) {
  int wText =   (rw /2);
  int hText  = (rh /4);
  int wBT = wText;
  int hBT = hText ;
  //textMode(CENTER);
  //fill(0,255,0);
  //Dibujar el rectangulo de la cara detectada
  //stroke(0,255,0);
  //rect(rx, ry, rw, rh);
  //Por cada rectangulo que encuentre dibujar palabras a su alrededor
  ///translate(-407, -17);
  //pushMatrix();
  for (int i = 0; i <= quien.length-1; i++) {
    //Dibujar la matrix de palabras
    for (int ubicaX = 0; ubicaX <= width; ubicaX += wText  ) {
      for (int ubicaY = 0; ubicaY <= height; ubicaY += hText ) {
        int palabra = int (random(0, 3));
        if (!(ubicaX >= rx - wText && ubicaY >= ry - hText ) || !(ubicaX <= ( rx + rw )  && ubicaY <= ( ry + rh + hText )) ) {
          //dib.beginDraw();
          translate(0, 0);
          //dib.pushMatrix();
          //dib.image(imgF, 0, 0);
          fill(0);
          textFont(font, wText / 5  );
          text(tu + " " + quien[palabra], ubicaX, ubicaY, wText, hText);
          //dib.popMatrix();
          //dib.endDraw();
        }
      }
    }
  }

  //popMatrix();
}
/*
Activa el sonido 
*/
void activarSampleo(){
  /*
  
  Aqui debe de ir eel proceso de seleccion del sampleo
  asi como su activacion y monitoreo de tiempo
  */
  
}

void actualizarFondo() {
  println("Actualizado");
  captura.loadPixels();
  arraycopy(captura.pixels, fondoPixeles);
  fondoC.beginDraw();
  //Iteracion de colocación de pixeles
  for (int i = 0; i <= captura.pixels.length-1; i++) {
    captura.pixels[i] = fondoPixeles[i];
  }
  fondoC.endDraw();
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    actualizarFondo();
  }
}