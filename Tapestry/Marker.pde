class Marker {
  ArrayList<PVector> waypoints;
  float speed;
  PVector pos;
  float waypointCursor;
  Scene scene;
  boolean active = false;
  float s = 1;
  float ts = 1;
  PImage module;

  Marker () {}

  Marker init (Scene _scene, ArrayList<PVector> _waypoints, float _speed, PImage _module) {
    waypoints = _waypoints;
    speed = _speed * (random(0.75) + 0.75);
    pos = new PVector();
    waypointCursor = 0;
    scene = _scene;
    active = true;
    ts = 1;
    s = 0;
    module = _module;
    return this;
  }

  void update () {
    float cursorOffset = waypointCursor;
    for (int i = 0; i < waypoints.size() - 1; i++) {
      PVector v1 = waypoints.get(i);
      PVector v2 = waypoints.get(i + 1);
      float dist = PVector.dist(v1, v2);
      if (cursorOffset - dist <= 0) {
        float alpha = cursorOffset / dist;
        pos = v1.copy().lerp(v2, alpha);
        cursorOffset = 0;
        break;
      } else {
        cursorOffset -= dist;
      }
    }
    if (cursorOffset > 0) {
      kill();
    }
    waypointCursor += speed;
    s = lerp(s, ts, 0.1);
  }

  void render () {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    scale(s);
    image(module, 0, 0, height / 1.5, height / 1.5);
    // fill(255, 0, 0);
    // ellipse(0, 0, 80, 80);
    popMatrix();
  }

  void kill () {
    active = false;
  }
}