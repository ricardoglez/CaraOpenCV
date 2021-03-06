import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import ddf.minim.*;

int numAudios = 24;
String tu = "TU";
String[] quien = { "MADRE", "HERMANA", "NOVIA", "ABUELA"};
PImage imgF;
PFont f;
boolean[] audioAc = new boolean[numAudios];

Minim minim;
AudioPlayer[] sample = new AudioPlayer[numAudios];
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
  background(255);
  //println(Capture.list());
  //Inicializacion de captura, procesos de CV y creación de lienzo
  fondoPixeles = new int[width * height];
  minim = new Minim(this);
  captura = new Capture(this, 320, 240,"/dev/video0",30);
  captura.start();
  hayAlguien = false;
  f = loadFont("Courier10PitchBT-Roman-48.vlw");
  imgF = loadImage("fondo.jpg");
  caraCV = new OpenCV(this, captura);
  caraCV.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  contornos = new OpenCV(this, captura);
  contornos.gray();
  contornos.threshold(57);
  contornos.startBackgroundSubtraction(20, 10, .02);
  String filename = "Sample" ;
  String ext = ".mp3" ;
  String archivo;
  for (int i = 0; i <= numAudios-1; i++) {
    String n =   str(i);
    archivo = filename +"0"+ n + ext;
    //println(archivo);
    sample[i] = minim.loadFile(archivo, 2048);
    if ( sample[i] == null ) {
      println("Nariz de codorniz", sample[i]);
    }
    audioAc[i] = false;
    println("Cargando ..."+ i+" "+archivo);
  }
  println("Carga Completa...");
  fondoC = createGraphics(width, height);
  dib = createGraphics(width, height);
  //caras = caraCV.detect();
  //frameRate(10);
}
/*/////////////////////7
 LOOP INICIAL
 Todo lo que sucede aqui se trabaja en la capa base de processing
 *////////////////////////
void draw() {
  pushMatrix();
  translate(84, -55);
  scale(3.1);
  background(255);
  //fill(50,50,50,100);
  stroke(0);
  noFill();
  //image(fondoC, -127, -26);
  preprocessings();
  // comienza el procesos de detección
  if (startDet()) {
    tint(256, 255, 256, 63);
    dibujarFondo();
    
  }
  popMatrix();
}

/*/////////////////////////////////////////////////////////////////
 Aqui se cargan las imagenes y se preprocesan para la vision computarizada
 */////////////////////////////////////////////////////////////////////
void preprocessings(){
  // Leer y cargar la captura al opencv
  captura.read();
  caraCV.loadImage(captura);
  contornos.loadImage(captura);
  contornos.threshold(68);
  contornos.updateBackground();
  contornos.dilate();
  contornos.erode();
  contours = contornos.findContours();
}
/*///////////////////////////////////
 Dibujar Contornos encontrados
 *////////////////////////////////////
void dibujarContornos( float size) {
  translate(-42, -17);
  pushMatrix();
  scale(1.4);
  stroke(0);
  fill(0, 0, 0, 0);
  strokeWeight(size);
  for (Contour contour : contours) {
    contour.draw();
  }
  popMatrix();
}
/*/////////////////////////////////////77
 Detecta si hay alguna cara en la escena
 *///////////////////////////////////
boolean startDet() {
  int x_, y_;
  caras = caraCV.detect();
  if (caras.length != 0) { //Si detecta alguna caraCV ..
    hayAlguien = true;
    for (int i = 0; i < caras.length; i++) { // Dibuja x por cada caraCV ...
      //dibujarFondo();
      x_ = caras[i].x; // ubicacion del rostro x
      y_ = caras[i].y; // ubicacion del rostro y
      //dibujarFondo();// Dibujar el texto como matriz, necesita la ubicacion, el tamaño del rostro y la fuente que usara el text
      dTextoFull(x_, y_, caras[i].width, caras[i].height, f);
      dibujarContornos(.2);
    }
  } else { // Si no detecta nada ...
    // Dibujar el fondo Fijo
    dib.beginDraw();
    dib.background(249, 0 );
    dib.endDraw();
    hayAlguien= false;
    dibujarFondo();
  }
  return hayAlguien;
}
/*//////////////////////////7
 Dibujar el fondo en la capa fondoC
 *////////////////////////////7
void dibujarFondo() {
  fondoC.beginDraw();
  fondoC.background(0,0,0,255);
  fondoC.endDraw();
  pushMatrix();
  fondoC.beginDraw();
  fondoC.translate(2, 4);
  fondoC.scale(1.4);
  //fondoC.background(6, 178);
  //fondoC.image(captura, 59, 3);
  fondoC.endDraw();

  
 popMatrix();
  
}
/*///////////////////////////////////////////////////
 Dibujar la matriz de texto al rededor de las caras
 es necesario ingresar x,y , h, w, Pfont
 *///////////////////////////////////////////////////
void dTextoFull(int rx, int ry, int rh, int rw, PFont font) {
  int wText =   (rw /4);
  int hText  = (rh /3); 

  int cual = int(map(rw, 20, 140, 1, numAudios-1));
  cual = constrain(cual, 1, numAudios-1);
  //println(" # ", cual, " Long: ", sample[cual].length(), " Position: ", sample[cual].position(), " Levels: ", sample[cual].right.level());
  if (sample[cual].right.level() == 0) {
    //println(sample[cual].position());
    sample[cual].skip(-sample[cual].length());
    //println("esta ya habia pasado regresate", sample[cual].position());
  }
  sample[cual].play();
  //Dibujar el rectangulo de la cara detectada
  //stroke(0,255,0);
  //fill(0,255,0);
  //rect(rx, ry, rw, rh);
  //Por cada rectangulo que encuentre dibujar palabras a su alrededor
  //translate(-407, -17);
  pushMatrix();
  //translate(random(0, 3), random(-3, 4));
  for (int i = 0; i <= quien.length-1; i++) {
    //Dibujar la matrix de palabras
    for (int ubicaX = 0; ubicaX <= width/2; ubicaX += wText  ) {
      for (int ubicaY = 0; ubicaY <= height/2; ubicaY += hText ) {
        int palabra = int (random(0, 3));
        if (!(ubicaX >= rx - wText && ubicaY >= ry - hText ) || !(ubicaX <= ( rx + rw )  && ubicaY <= ( ry + rh + hText )) ) {
          translate(random(0, 3), sin(rh)*map(rw, 10, 150, 3, 7));
          fill(0, 8, 10, 255);
          textFont(font, wText / int(random(1, 6)));
          text(tu + "           " + " \n" + quien[palabra]+ " \n", ubicaX+-90, ubicaY+-1, wText+116, hText+14);
        }
      }
    }
  }
  popMatrix();
}
/*
Activa el sonido
 */
void activarSampleo() {
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