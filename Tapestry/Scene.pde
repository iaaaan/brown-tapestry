class Scene {
  String id = "blank";
  int life = 0;
  float gutterX = 0;
  float gutterY = 0;
  float margin = 0;
  float[] triggers = {100, 500, 1000, 1300};
  boolean done = false;
  int maxLifespan = 60 * 60;

  Scene () {}

  Scene init () {
    life = 0;
    done = false;
    return this;
  }

  void update () {
    life ++;
  }

  void render () {
    background(0);
  }

  void kill () {
    println("killing scene:", id);
  }

  void fadeOut () {
    println("fading out:", id);
  }
}