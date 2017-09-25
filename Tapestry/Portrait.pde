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
    thresholds[0] = 100;
    thresholds[1] = 500;
    thresholds[2] = 1000;
    thresholds[3] = 1500;

    col = c;
    return this;
  }

  void update () {
    if (status == 0 && scene.life > thresholds[0]) {
        status = 1;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!1", w, h, x, y);
    }
    if (status == 1 && scene.life > thresholds[1]+1) {
        status = 2;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!2", w, h, x, y);
    }    
    if (status == 2 && scene.life > thresholds[2]+2) {
        status = 3;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!3", w, h, x, y);
    }    
    if (status == 3 && scene.life > thresholds[3]+3) {
        status = 4;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!4", w, h, x, y);
    }    
    angle = lerp(angle, tAngle,0.05);
  }

  void render () {
    if (status == 1) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);          
      rotateY(PI);
      translate(0,0,1);
      fill(0);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 2) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      // tint(col);
      image(img,-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 3) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      // tint(col);
      image(img,-w/2.0,0,w,h);   
      popMatrix();
    }    
    if (status == 4) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(0);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }
  }
}