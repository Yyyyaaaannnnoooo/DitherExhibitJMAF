Dither d;
PImage img;
void settings() {  
  img = loadImage("me.jpg");  
  //size(1000, 700);
  fullScreen();
}
void setup() {
  d = new Dither();
  d.generateDither();
}
void draw() {
  image(d.ditheredImageEnlarged(), 0, 0);
  //d.generateDither();
  //d.displayDither(0);
}
void mouseMoved() {
  colorMode(HSB);
  color c1 = color(map(mouseX, 0, width, 0, 255), 255, 255);
  color c2 = color(map(mouseY, 0, height, 0, 255), 255, 255);
  colorMode(RGB);
  d.setColor(c1, c2);
  //d.generateDither();
}
void keyPressed() {
  saveFrame("output"+d.pixSize+".png");  
  saveFrame("output"+d.pixSize+".jpg");
}
