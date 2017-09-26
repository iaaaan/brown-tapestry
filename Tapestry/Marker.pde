class Marker {
  ArrayList<PVector> waypoints;
  float speed;
  PVector pos;
  float waypointCursor;
  Scene scene;
  boolean active = false;

  Marker () {}

  Marker init (Scene _scene, ArrayList<PVector> _waypoints, float _speed) {
    waypoints = _waypoints;
    speed = _speed;
    pos = new PVector();
    waypointCursor = 0;
    scene = _scene;
    active = true;
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
  }

  void render () {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(255, 0, 0);
    ellipse(0, 0, 40, 40);
    popMatrix();
  }

  void kill () {
    active = false;
  }
}