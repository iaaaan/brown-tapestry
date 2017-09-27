

class IntroductionScene extends Scene {

  Movie introMovie;
  Movie thankYouMovie;
  int run;
  int step;
  boolean paused = false;

  IntroductionScene (PApplet sketch) {
    id = "intro";
    // introMovie = new Movie(sketch, "Showcase_v12_092717_30fps.mov");
    // introMovie = new Movie(sketch, "showcase_welcome_v3_092717_lowRes.mp4");
    // introMovie = new Movie(sketch, "Showcase_v11_092717_30fps.mp4");
    thankYouMovie = new Movie(sketch, "capture-rotation.mov");
  }

  IntroductionScene init (int _run) {
    super.init();
    println("init intro scene");
    run = _run;

    step = 0;
    // introMovie.frameRate(60);
    introMovie.play();
    // introMovie.speed(4.0);
    ortho();
    // frameRate(0);

    return this;
  }

  void update () {
    super.update();
    if (!paused) {
      if (run == 0) {
        // println("aga", introMovie.duration() - introMovie.time());
        if (step == 0) {
          if (introMovie.duration() - introMovie.time() <= 2) {
            println("pausing introduction 1");
            introMovie.pause();
            paused = true;
          }
        } else {
          if (!paused && introMovie.duration() - introMovie.time() <= 0) {
            println("introduction 1 ending");
            introMovie.stop();
            step = 1;
            sceneManager.pause();
          }
        }
      } else {
        if (step == 0 && introMovie.duration() - introMovie.time() <= 0) {
          println("introduction 2 ending");
          introMovie.stop();
          thankYouMovie.play();
          step = 1;
        }
        if (step == 1 && thankYouMovie.duration() - thankYouMovie.time() <= 0) {
          println("thank you ending");
          thankYouMovie.stop();
          step = 0;
          sceneManager.pause();
        }
      }
    }
  }

  void resume () {
    if (paused && run == 0 && step == 0) {
      println("resuming introduction 1");
      introMovie.play();
      paused = false;
      step = 1;
    }
  }

  void render () {
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective();
    if (!paused) {
      imageMode(CORNER);
      super.render();
      background(0);
      if (run == 0) {
        image(introMovie, 0, 0, width, height);
      } else {
        if (step == 0) {
          image(introMovie, 0, 0, width, height);
        } else {
          image(thankYouMovie, 0, 0, width, height);
        }
      }
    }
  }

  

  void kill () {
    super.kill();
    introMovie.stop();
    thankYouMovie.stop();
    // frameRate(60);
  }

}