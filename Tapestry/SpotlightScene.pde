

class SpotlightScene extends Scene {

  PVector pos;
  PVector tpos;
  float alpha;
  float tAlpha;

  SpotlightScene () {
    id = "spotlight";
  }

  SpotlightScene init () {
    super.init();
    println("init spotlight scene");
    pos = new PVector(screenWidth / 1.115, -screenWidth / 10, 200 / scaleFactor);
    tpos = new PVector(screenWidth / 1.37, screenHeight / 1.8, 0);
    alpha = 0;
    tAlpha = 1;
    return this;
  }

  void update () {
    super.update();
    pos.lerp(tpos, 0.07);
    alpha = lerp(alpha, tAlpha, 0.1);
  }

  void render () {
    super.render();
    background(0);
    perspective();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(255, 225, 180, alpha * 255);
    rectMode(CENTER);
    rect(0, 0, screenWidth / 8, screenWidth / 8, screenWidth / 40);
    rectMode(CORNER);
    popMatrix();
  }

  void kill () {
    super.kill();
  }

  void fadeOut () {
    tpos = new PVector(screenWidth / 1.215, -screenWidth / 10, 200 / scaleFactor);
    tAlpha = 0;
  }


}