

class Segment {
  String copy;
  float fontSize;
  Scene scene;

  PVector pos;
  PVector tpos;
  float rot;
  float trot;
  float alpha = 0;
  float tAlpha = 1;

  PVector[] absolutePos;


  Segment () {}

  Segment init (Scene _scene, String _copy, float _fontSize, float x, float y, float _rot) {
    copy = _copy;
    fontSize = _fontSize;
    pos = new PVector(x, y, 0);
    tpos = new PVector(x, y, 0);
    rot = _rot;
    trot = _rot;
    scene = _scene;

    textSize(fontSize);
    float sentenceWidth = textWidth(copy);
    absolutePos = new PVector[2];
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotate(rot);
    absolutePos[0] = new PVector(
      modelX(0, 0, 0),
      modelY(0, 0, 0),
      modelZ(0, 0, 0)
    );
    absolutePos[1] = new PVector(
      modelX(sentenceWidth, 0, 0),
      modelY(sentenceWidth, 0, 0),
      modelZ(sentenceWidth, 0, 0)
    );
    popMatrix();

    alpha = 0;
    tAlpha = 1;

    return this;
  }

  void update () {
    pos.lerp(tpos, 0.1);
    rot = lerp(rot, trot, 0.1);
    alpha = lerp(alpha, tAlpha, 0.1);
  }

  void render () {
    textSize(fontSize);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotate(rot);
    fill(25, alpha * 255);
    textSize(fontSize);
    text(copy, 0, textAscent() / 2.0);
    popMatrix();
  }
}