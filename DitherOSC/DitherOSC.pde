import oscP5.*;
import netP5.*;
OscP5 oscP5;

Dither d;

final private String PAGE = "/DITHER";
final private String BW = "/BW";
final private String RADIAL = "/RADIAL";
final private String PIXEL = "/PIXEL";
final private String FACTOR = "/FACTOR";
final private String COL1 = "/COL1";
final private String COL2 = "/COL2";
final private String pix1 = "/pix1";
final private String pix2 = "/pix2";
final private String pix3 = "/pix3";
final private String pix4 = "/pix4";
final private String pix5 = "/pix5";
final private String pix6 = "/pix6";
final private String pix7 = "/pix7";
final private String pix8 = "/pix8";
final private String pix9 = "/pix9";

float c1 = 0;
float c2 = 255;

float[][] ditherKernel = {{0, 0, 0 }, {0, 0, 7.0}, {3.0, 5.0, 1.0}};//STEINBERG

boolean isBW = false;
int currVal = 0;
int prevVal = 0;

void setup() {
  //size(800, 600);
  fullScreen();
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this, 8000);
  // initialize Dither
  d = new Dither();
  d.generateDither();
}
void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();
  //println(addr);
  if (addr.equals(PAGE + BW)) { 
    d.setBW(val == 1 ? true : false, c1, c2);
    println(val);
  } else if (addr.equals(PAGE + RADIAL)) { 
    d.setRadiant(val == 1 ? true : false);
    println(val);
  } else if (addr.equals(PAGE + PIXEL)) { 
    currVal = floor(val);
    if (currVal != prevVal) {
      prevVal = currVal;
      d.setPixelSize(currVal);
    }
    println(currVal);
  } else if (addr.equals(PAGE + FACTOR)) { 
    d.setFactor(val);
    println(val);
  } else if (addr.equals(PAGE + COL1)) { 
    c1 = val;
    d.setColor(c1, c2);
    println(val);
  } else if (addr.equals(PAGE + COL2)) { 
    c2 = val;
    d.setColor(c1, c2);
    println(val);
  } else if (addr.equals(PAGE + pix1)) { 
    ditherKernel[0][0] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix2)) { 
    ditherKernel[0][1] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix3)) { 
    ditherKernel[0][2] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix4)) { 
    ditherKernel[1][0] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix5)) { 
    ditherKernel[1][1] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix6)) { 
    ditherKernel[1][2] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix7)) { 
    ditherKernel[2][0] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix8)) { 
    ditherKernel[2][1] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  } else if (addr.equals(PAGE + pix9)) { 
    ditherKernel[2][2] = round(val);
    d.setKernel(ditherKernel);
    println(val);
  }
}

void draw() {
  PImage display = d.ditheredImageEnlarged();
  image(display, 0, 0);
}

color returnHSB(float value) {
  colorMode(HSB);
  color c = color(value, 255, 255);
  colorMode(RGB);
  return c;
}
