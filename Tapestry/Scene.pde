class Scene {
  String id = "blank";
  int life = 0;

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