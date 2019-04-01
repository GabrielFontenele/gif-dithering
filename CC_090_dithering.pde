// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain

// Floyd Steinberg Dithering
// Edited Video: https://youtu.be/0L2n8Tg2FwI
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
  PImage getCimag(){
    PImage img = images[frame];
    return img.copy();
  }
}

float phase = 0;
float zoff = 0;
Animation kitten;
PImage kitten1;
float h =0;
float j =1;

float radius = 100;

void setup() {
  kitten = new Animation("gif",5);
  size(1025, 400);
  frameRate(8);
}

int index(int x, int y) {
  return x + y * kitten.getWidth();
}

void draw() {
  kitten.display(0,0);
  kitten1 = kitten.getCimag();
  kitten1.loadPixels();
  for (int y = 0; y < kitten1.height-1; y++) {
    for (int x = 1; x < kitten1.width-1; x++) {
      color pix = kitten1.pixels[index(x, y)];
      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);
      float factor = j;
      float newR = round(factor * oldR / 255) * (255/factor);
      float newG = round(factor * oldG / 255) * (255/factor);
      float newB = round(factor * oldB / 255) * (255/factor);
      kitten1.pixels[index(x, y)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;


      int index = index(x+1, y  );
      color c = kitten1.pixels[index];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      r = r + errR * 7/16.0;
      g = g + errG * 7/16.0;
      b = b + errB * 7/16.0;
      kitten1.pixels[index] = color(r, g, b);

      index = index(x-1, y+1  );
      c = kitten1.pixels[index];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 3/16.0;
      g = g + errG * 3/16.0;
      b = b + errB * 3/16.0;
      kitten1.pixels[index] = color(r, g, b);

      index = index(x, y+1);
      c = kitten1.pixels[index];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 5/16.0;
      g = g + errG * 5/16.0;
      b = b + errB * 5/16.0;
      kitten1.pixels[index] = color(r, g, b);


      index = index(x+1, y+1);
      c = kitten1.pixels[index];
      r = red(c);
      g = green(c);
      b = blue(c);
      r = r + errR * 1/16.0;
      g = g + errG * 1/16.0;
      b = b + errB * 1/16.0;
      kitten1.pixels[index] = color(r, g, b);
    }
  }
  kitten1.updatePixels();
  image(kitten1, kitten1.width, 0);
  
  float scale = 0.5;
  if(h<10000){
    
    float ns = (float)noise(scale*h,radius*cos(TWO_PI),radius*sin(TWO_PI));
    j = map(ns,-1,1,0.5,3);
    h++;
  }else{
    h = 1;
  }
}
