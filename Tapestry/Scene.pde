class Scene {
  String id = "blank";
  int life = 0;
  float gutterX = 0;
  float gutterY = 0;
  float margin = 0;
  float[] triggers = {100, 500, 1000, 1300};

  Scene () {}

  Scene init () {
    life = 0;
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
}