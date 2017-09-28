

class ModuleScene extends Scene {

  Movie introMovie;
  float alpha = 0;
  float tAlpha = 0;

  ModuleScene (PApplet sketch) {
    id = "module";
    introMovie = new Movie(sketch, "Showcase_v12_092717_30fps.mov");
  }

  ModuleScene init () {
    super.init();
    println("init module scene");
    introMovie.play();

    alpha = 0;
    tAlpha = 0;
    return this;
  }

  void update () {
    super.update();
    alpha = lerp(alpha, tAlpha, 0.08);
  }

  void render () {
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective();
    imageMode(CORNER);
    super.render();
    background(0);
    image(introMovie, 0, 0, width, height);
    fill(0, alpha * 255);
    rect(0, 0, width, height);
  }

  void kill () {
    super.kill();
    introMovie.stop();
  }

  void fadeOut () {
    tAlpha = 1;
  }

}