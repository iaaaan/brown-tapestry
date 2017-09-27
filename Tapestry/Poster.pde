
class Poster {
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
  PVector[] origins = new PVector[4];

  float noiseScaleFactor = 0.3;

  Poster () {}

  Poster init (Scene _scene, PImage _img, float _w, float _h, int _x, int _y, color c, int hCount, int vCount) {
    scene = _scene;
    img = _img;
    w = _w;
    h = _h;
    x = _x;
    y = _y;

    origins[0] = new PVector();
    origins[1] = new PVector();
    origins[2] = new PVector();
    origins[3] = new PVector();

    noiseSeed(0);
    thresholds[0] = noise(x * noiseScaleFactor, y * noiseScaleFactor) * 200 + 100;
    
    float minThreshold = 1;
    for (int i = -1; i <= 1; i++) {
      if (x + i >= 0 && x + i <= hCount) {
        float n = noise((x + i) * noiseScaleFactor, y * noiseScaleFactor);
        if (minThreshold > n) {
          minThreshold = n;
          origins[0] = new PVector(i, 0);
        }
      }
    }

    noiseSeed(100);
    thresholds[1] = noise(x * noiseScaleFactor, y * noiseScaleFactor) * 200 + 500;

    noiseSeed(1000);
    thresholds[2] = noise(x * noiseScaleFactor, y * noiseScaleFactor) * 200 + 1000;

    noiseSeed(10000);
    thresholds[3] = (1 - noise(x * noiseScaleFactor, y * noiseScaleFactor)) * 200 + 1300;
    
    minThreshold = 1;
    for (int i = -1; i <= 1; i++) {
      if (x + i >= 0 && x + i <= hCount) {
        float n = noise((x + i) * noiseScaleFactor, y * noiseScaleFactor);
        if (minThreshold > n) {
          minThreshold = n;
          origins[3] = new PVector(i, 0);
        }
      }
    }

    status = 0;
    col = c;
    return this;
  }

  void update () {
    if (status == 0 && scene.life > thresholds[0]) {
        status = 1;
        angle = PI + PI / 2;
        tAngle = TWO_PI;
    }
    if (status == 1 && scene.life > thresholds[1]) {
        status = 2;
        angle = PI;
        tAngle = TWO_PI;
    }    
    if (status == 2 && scene.life > thresholds[2]) {
        status = 3;
        angle = PI;
        tAngle = TWO_PI;
    }    
    if (status == 3 && scene.life > thresholds[3]) {
        status = 4;
        angle = TWO_PI;
        tAngle = PI;
    }    
    angle = lerp(angle, tAngle, 0.1);
  }

  void render () {

    if (status == 0 || (status == 4 && angle <= PI + PI / 2)) return;

    float gutterX = 0;
    float gutterY = width / 25;
    float margin = width / 140;
    pushMatrix();
    translate(gutterX-width/2.0+x*(w+margin)+margin+w/2.0, gutterY-height/2.0+margin+y*(h+margin));

    if (status == 1 || status == 4) {
    // if (status == 1) {
      translate(origins[status - 1].x * w / 2.0, origins[status - 1].y * h / 2.0);
      if (abs(origins[status - 1].x) > abs(origins[status -1].y)) {
        if (origins[status - 1].x > 0) {
          rotateY(angle);
        } else {
          rotateY(-angle);
        }
      } else {
        if (origins[status - 1].y > 0) {
          rotateX(-angle);
        } else {
          rotateX(angle);
        }
      }
      translate(-origins[status - 1].x * w / 2.0, -origins[status - 1].y * h / 2.0);
    } else {
      rotateY(angle);
    }

    switch (status) {
      case 1:
        fill(col);
      rect(-w/2.0,0,w,h);
        break;
      case 2:
        image(img,-w/2.0,0,w,h);
        break;
      case 3:
        fill(col);
        rect(-w/2.0,0,w,h);
        break;
      case 4:
        fill(col);
        rect(-w/2.0,0,w,h);
        break;
    }

    rotateY(PI);
    translate(0,0,0.01);

    switch (status) {
      case 1:
        fill(0);
        rect(-w/2.0,0,w,h);
        break;
      case 2:
        fill(col);
        rect(-w/2.0,0,w,h);
        break;
      case 3:
        image(img,-w/2.0,0,w,h);
        break;
      case 4:
        fill(0);
        rect(-w/2.0,0,w,h);
        break;
    }
    popMatrix();
  }
}