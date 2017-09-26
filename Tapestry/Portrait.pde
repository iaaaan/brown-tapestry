/*
  tinting
  other data
  origami animation
*/

class Portrait {
  Scene scene;
  PImage img;
  float w = 0;
  float h = 0;
  int x = 0;
  int y = 0;
  int status = 0;
  float angle = TWO_PI;
  float tAngle = TWO_PI;
  color col;
  float[] thresholds = new float[4];

  Portrait () {}

  Portrait init (Scene _scene, PImage _img, float _w, float _h, int _x, int _y, color c) {
    scene = _scene;
    img = _img;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    noiseSeed(0);
    thresholds[0] = noise(x, y) * 200 + 100;
    noiseSeed(100);
    thresholds[1] = noise(x, y) * 200 + 500;
    noiseSeed(1000);
    thresholds[2] = noise(x, y) * 200 + 1000;
    noiseSeed(10000);
    thresholds[3] = noise(x, y) * 200 + 1500;

    col = c;
    return this;
  }

  void update () {
    if (status == 0 && scene.life > thresholds[0]) {
        status = 1;
        angle = PI;
        tAngle = TWO_PI;
    }
    if (status == 1 && scene.life > thresholds[1]+1) {
        status = 2;
        angle = PI;
        tAngle = TWO_PI;
    }    
    if (status == 2 && scene.life > thresholds[2]+2) {
        status = 3;
        angle = PI;
        tAngle = TWO_PI;
    }    
    if (status == 3 && scene.life > thresholds[3]+3) {
        status = 4;
        angle = PI;
        tAngle = TWO_PI;
    }    
    angle = lerp(angle, tAngle, 0.1);
  }

  void render () {
    // 3840
    // float gutterX = width / 42.5;
    // float gutterY = width / 27.5;
    float gutterX = 0;
    float gutterY = width / 50;
    float margin = width / 140;
    if (status == 1) {
      pushMatrix();
      translate(gutterX-width/2.0+x*(w+margin)+margin+w/2.0, gutterY-height/2.0+margin+y*(h+margin));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);          
      rotateY(PI);
      translate(0,0,0.01);
      fill(0);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 2) {
      pushMatrix();
      translate(gutterX-width/2.0+x*(w+margin)+margin+w/2.0, gutterY-height/2.0+margin+y*(h+margin));
      rotateY(angle);
      // tint(col);
      image(img,-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,0.01);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 3) {
      pushMatrix();
      translate(gutterX-width/2.0+x*(w+margin)+margin+w/2.0, gutterY-height/2.0+margin+y*(h+margin));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,0.01);
      // tint(col);
      image(img,-w/2.0,0,w,h);   
      popMatrix();
    }    
    if (status == 4) {
      pushMatrix();
      translate(gutterX-width/2.0+x*(w+margin)+margin+w/2.0, gutterY-height/2.0+margin+y*(h+margin));
      rotateY(angle);
      fill(0);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,0.01);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }
  }
}