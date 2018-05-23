class Dither {
  public int pixSize = 20, charXline = 42, col = 255;
  public float factor = 16;
  float [][] kernel;
  boolean isRadiant = false, isDitherImage = false, isBW = false;
  color col1 = color(100, 20, 147), col2 = color(55, 150, 20);
  PVector[] colorPalette = {
    new PVector(col, 0, 0), 
    new PVector(0, col, 0), 
    new PVector(0, 0, col), 
    new PVector(col, col, 0), 
    new PVector(0, col, col), 
    new PVector(col, 0, col), 
    new PVector(0, 0, 0), 
    new PVector(col, col, col), 
    //new PVector(100, 180, 25),
  };
  private PImage dither, big, bigGradient, gradient = gradient();
  String kernelName = "";
  Dither() {
    initDither();
    isDitherImage = false;
  }
  Dither(PImage _img) {
    _img.resize(0, _img.height / pixSize);
    initDitherImage(_img);
    isDitherImage = true;
  }

  void initDither() {
    // this needs refactoring
    dither = createImage(floor(width / pixSize), floor(height / pixSize), RGB);
    big = createImage(floor(width / pixSize), floor(height / pixSize), RGB);
    bigGradient = createImage(floor(width / pixSize), floor(height / pixSize), RGB);
    //gradient = createImage(floor(width / num), floor(height / num), RGB);
    kernel = new float [3][3];
    kernel = CHRIS;
  }
  //initializing the dither in case of image
  void initDitherImage(PImage img) {
    dither = createImage(img.width, img.height, RGB);
    big = createImage(img.width, img.height, RGB);
    bigGradient = createImage(img.width, img.height, RGB);
    gradient = createImage(img.width, img.height, RGB);
    kernel = new float [3][3];
    kernel = TEST;
    arrayCopy(img.pixels, gradient.pixels);
  }
  /*
  * generates the dither
   */
  void generateDither() {
    dither = dither(gradient(), factor, kernel);
    big = nearestN(dither);
  }
  /**
   * @returns the dithered image in original size
   */
  PImage ditheredImage() {
    return dither;
  }
  /**
   * @returns the enlarged dithered image 
   */
  PImage ditheredImageEnlarged() {
    return big;
  }

  //the image must have the same size otherwise yeld error
  void setGradientImage(PImage img) {
    if (img.pixels.length == gradient.pixels.length) {
      gradient = img;
      generateDither();
    } else {
      println("THE IMAGE MUST HAVE THE SAME SIZE AS THE ORIGINAL DITHER IMAGE");
    }
  }
  void displayDither(int posX) {
    image(big, posX, 0);
  }
  void setPixelSize(int PS) {
    if (!isDitherImage) {
      pixSize = PS;
      initDither();
      generateDither();
    }
  }
  void setColor(float c1, float c2) {
    if (!isBW) {
      colorMode(HSB);
      col1 = color(c1, 255, 255);
      col2 = color(c2, 255, 255);
      colorMode(RGB);
    }else {
      col1 = color(c1);
      col2 = color(c2);
    }
    generateDither();
    //if (!isDitherImage) {
    //  col1 = c1;
    //  col2 = c2;
    //  //gradient = gradient();    
    //  generateDither();
    //}
  }
  void setRadiant (boolean bool) {
    if (!isDitherImage) {
      isRadiant = bool;
      gradient = gradient();    
      generateDither();
    }
  }
  void setBW(boolean bool, float c1, float c2) {
    isBW = bool;
    setColor(c1, c2);
    generateDither();    
  }
  void setFactor(float fac) {
    factor = fac; 
    generateDither();
  }
  void setKernel(float[][] k) {
    kernel = k;
    generateDither();
  }


  /// source image, 
  /// factor is a float that changes the amount of black of the image, and the structure of the dither
  private PImage dither(PImage img, float fac, float [][] k) {
    ///create a copy of the original image///
    PImage src = createImage(img.width, img.height, RGB);
    arrayCopy(img.pixels, src.pixels);
    src.loadPixels();
    int start = 1, end = src.height - 1, step = 1;
    for (int x = 1; x < src.width - 1; x += 1) {
      for (int y = 1; y < src.height - 1; y += 1) {
        int index = x + y * src.width;
        color oldpixel = src.pixels[index];
        color newpixel = findClosestColor(oldpixel); //con 8 pixel sorting
        src.pixels[index] = newpixel;
        color quant_error = subColor(oldpixel, newpixel);
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            color c = src.pixels[(x + kx) + ((y + ky) * src.width)];
            float num = k[kx + 1][ky + 1];
            if (num != 0) src.pixels[(x + kx)+ ((y + ky) * src.width)] = quantizedColor(c, quant_error, num / fac);//7.0
          }
        }
      }
    }
    src.updatePixels();
    return src;
  }
  /// find the nearest color, lev defines the number ///
  /// of colors the image will be divided,           /// 
  /// with 1 meaning 8 colors (RGB + CMYK + WHITE)   ///

  private color findClosestColor(color in) {//lev is deprecated

    int r = (in >> 16) & 0xFF;
    int g = (in >> 8) & 0xFF;
    int b = in & 0xFF;
    PVector c = new PVector(r, g, b);
    //color result = color(0);
    int current = 0;
    float dMin = 999999999.0;
    for (int i = 0; i < colorPalette.length; i++) {
      float d = PVector.dist(colorPalette[i], c);
      if (d <= dMin) {
        dMin = d;
        current = i;
      }
    }
    return color(colorPalette[current].x, colorPalette[current].y, colorPalette[current].z);
  }


  /////subtracting two different colors (a - b)////
  private color subColor (color a, color b) {

    int r1 = (a >> 16) & 0xFF;
    int g1 = (a >> 8) & 0xFF;
    int b1 = a & 0xFF;

    int r2 = (b >> 16) & 0xFF;
    int g2 = (b >> 8) & 0xFF;
    int b2 = b & 0xFF;

    int r3 = r1 - r2;
    int g3 = g1 - g2;
    int b3 = b1 - b2;

    color c = color(r3, g3, b3);
    return c;
  }

  /////returns the result between the original color and the quantization error////
  private color quantizedColor(color c1, color c2, float mult ) {

    int r1 = (c1 >> 16) & 0xFF;
    int g1 = (c1 >> 8) & 0xFF;
    int b1 = c1 & 0xFF;

    int r2 = (c2 >> 16) & 0xFF;
    int g2 = (c2 >> 8) & 0xFF;
    int b2 = c2 & 0xFF;

    float nR = r1 + mult * r2;
    float nG = g1 + mult * g2;
    float nB = b1 + mult * b2;

    color c3 = color (nR, nG, nB);
    return c3;
  }
  /*
  * @param {Pimage} img - the 
   */
  private PImage gradient() {
    color c1 = col1;
    color c2 = col2;
    boolean r = isRadiant;
    // this above needs further refactoring
    PImage img = createImage(floor(width / pixSize), floor(height / pixSize), RGB);
    img.loadPixels();
    if (r) {//if is radiant calculate a radiant gradient
      for ( int y = 0; y < img.height; y++) {
        for ( int x = 0; x < img.width; x++) {
          int i = x + img.width * y;
          float d = dist(x, y, img.width / 2, img.height / 2);
          float amp = map(d, 0, img.height / 2, 0, 1);
          color col = lerpColor(c1, c2, amp);
          img.pixels[i] = col;
        }
      }
    } else {//this is standard gradient maybe add a blob gradient
      for (int i = 0; i < img.pixels.length; i++) {
        float amp = map(i, 0, img.pixels.length, 0, 1);
        color col = lerpColor(c1, c2, amp);
        img.pixels[i] = col;
      }
    }
    img.updatePixels();
    return img;
  }
  /*
   * returns the dither enlarged!
   */
  private PImage nearestN(PImage img) {
    PImage destination;
    destination = createImage(img.width * pixSize, img.height * pixSize, RGB);
    destination.loadPixels();
    for ( int y = 0; y < img.height; y++) {
      for ( int x = 0; x < img.width; x++) {
        int i = x + img.width * y;
        int nX = x * pixSize;
        int nY = y * pixSize;
        //kernel loop//
        for ( int yy = 0; yy < pixSize; yy++) {
          for ( int xx = 0; xx < pixSize; xx++) {
            destination.pixels[((nX + xx) + destination.width * (nY + yy))] = img.pixels[i];
          }
        }
      }
    }
    destination.updatePixels();
    return destination;
  }

  private PImage nearestNThermo(PImage img, int num) {
    int numW = num / 2;//we need to make the image with tal rectangles instead of square pixels
    PImage destination;
    destination = createImage(img.width * numW, img.height * num, RGB);
    destination.loadPixels();
    for ( int y = 0; y < img.height; y++) {
      for ( int x = 0; x < img.width; x++) {
        int i = x + img.width * y;
        int nX = x * numW;
        int nY = y * num;
        //kernel loop//
        for ( int yy = 0; yy < num; yy++) {
          for ( int xx = 0; xx < numW; xx++) {
            destination.pixels[((nX + xx) + destination.width * (nY + yy))] = img.pixels[i];
          }
        }
      }
    }
    destination.updatePixels();
    return destination;
  }

  void changeKernel(int i) {
    switch (i) {
    case 0:
      kernel = STEINBERG;
      kernelName = "STEINBERG";
      break;
    case 1:
      kernel = LINEARRANDOM;
      kernelName = "LINEARRANDOM";
      break;
    case 2:
      kernel = FALSESTEINBERG;
      kernelName = "FALSESTEINBERG";
      break;
    case 3:
      kernel = PARTIALBURKE;
      kernelName = "PARTIALBURKE";
      break;
    case 4:
      kernel = INVERTEDSTEINBERG;
      kernelName = "INVERTEDSTEINBERG";
      break;
    case 5:
      kernel = SLANTED;
      kernelName = "SLANTED";
      break;
    case 6:
      kernel = COOL01;
      kernelName = "COOL01";
      break;
    case 7:
      kernel = COOL02;
      kernelName = "COOL02";
      break;
    case 8:
      kernel = COOL03;
      kernelName = "COOL03";
      break;
    case 9:
      kernel = COOL04;
      kernelName = "COOL04";
      break;
    case 10:
      kernel = COOL05;
      kernelName = "COOL05";
      break;
    case 11:
      kernel = COOL06;
      kernelName = "COOL06";
      break;
    case 12:
      kernel = CHRIS;
      kernelName = "CHRIS";
      break;
    case 13:
      kernel = STRUCTURE;
      kernelName = "STRUCTURE";
      break;
    }
  }

  float[][] STEINBERG = {{0, 0, 0 }, {0, 0, 7.0}, {3.0, 5.0, 1.0}};//7
  float[][] TEST = {{0, 0, 0 }, {0, 0, 5.0}, {10.0, 2.0, 35.0}};//7
  float[][] LINEARRANDOM = {{0, 3.0, 0}, { 5.0, 0, 1.0}, {0, 7.0, 0}};///linear 2
  float[][] FALSESTEINBERG = {{0, 0, 0}, {0, 0, 3.0}, {0, 3.0, 2.0}};///false seinberg factor 8 4
  float[][] PARTIALBURKE = {{0, 0, 0}, {0, 0, 8.0}, {4.0, 8.0, 4.0}};//part of burke factor 32 // really nice at low  factor 3.9 and level 2
  float[][] INVERTEDSTEINBERG = {{1.0, 5.0, 3.0}, {7.0, 0, 0}, {0, 0, 0}};//8
  //8.433198 | 3.2546508 | 3.9625964 | 0.0 | 7.693716 | 0.0 | 8.920265 | 1.7277707 | 0.0 |
  float[][] SLANTED = {{8.0, 0, 9.0}, {3.0, 8.0, 2.0}, {4.0, 0, 0}};//10
  float[][] COOL01 = {{0, 5.0, 0}, {0, 0, 1.0}, {3.0, 0, 7.0}};///coool kernel 1
  float[][] COOL02 = {{0, 0, 0}, {5.0, 0, 3.0}, { 7.0, 0, 0}};///cool 2 3
  //4.0718956 | 8.834968 | 0.0 | 6.1390076 | 1.7300752 | 8.536661 | 0.0 | 2.5298612 | 0.0 | Very Cool
  float[][] COOL03 = {{4.0, 9.0, 0.0}, {6.0, 2.0, 9.0}, {0, 3.0, 0}};//11
  //0.0 | 0.0 | 3.1726065 | 7.5329027 | 0.0 | 4.401523 | 1.5556533 | 5.9921546 | 1.4675739 | nice
  float[][] COOL04 = {{0, 0, 3.0}, {8.0, 0, 4.0}, {2.0, 6.0, 1.0}};//12
  //0.0 | 8.747081 | 6.04726 | 8.657113 | 0.0 | 5.8474283 | 1.3418581 | 5.7040114 | 0.0 | nice 3
  float[][] COOL05 = {{0.0, 9.0, 6.0}, {9.0, 0.0, 6.0}, {1.0, 6.0, 0.0}};//13
  //6.564631 | 0.0 | 6.814121 | 0.0 | 6.3458323 | 3.4435391 | 0.0 | 4.157616 | 5.9172835 | vertical horizontal lines
  float[][] COOL06 = {{7.0, 0.0, 7.0}, {0.0, 6.0, 3.0}, {0.0, 4.0, 6.0}};//14
  //0.0 | 0.0 | 0.6782781 | 0.0 | 0.0 | 3.9686522 | 6.8295755 | 3.8442783 | 2.198808 |//ADD IT!
  float[][] CHRIS = {{0.0, 0.0, 1.0}, {0.0, 0.0, 4.0}, {7.0, 4.0, 2.0}};//15
  float[][] STRUCTURE = {{1.0, 0, 0}, {7.0, 0, 6.0}, {0, 2.0, 0}};///really nice structure
}
