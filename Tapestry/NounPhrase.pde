
class NounPhrase {
  String copy;
  float fontSize;
  // float x;
  // float y;
  Scene scene;
  float interval = 20;
  float[] alphas;
  float speedFactor = 30;
  PVector pos;
  PVector tpos;
  int focusState = 0;

  NounPhrase () {}

  NounPhrase init (Scene _scene, String _copy, float _fontSize, float x, float y) {
    copy = _copy;
    fontSize = _fontSize;
    pos = new PVector(x, y, 0);
    tpos = new PVector(x, y, 0);
    scene = _scene;
    alphas = new float[copy.length()];
    return this;
  }

  void update () {
    pos.lerp(tpos, 0.2);
  }

  void render () {
    textSize(fontSize);
    float characterWidth = textWidth("a");
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    float highlightIndex = (scene.life / speedFactor) % interval; 
    for (int i = 0; i < copy.length(); i++) {
      float index = i % interval;
      int distToHighlight = int(index <= highlightIndex ? highlightIndex - index : highlightIndex + interval - index);
      float targetAlpha = 0;
      if (focusState == -1) {
        targetAlpha = map(distToHighlight, 0, (interval - 5), 0.15, 0) * 255;
      } else if (focusState == 0) {
        targetAlpha = map(distToHighlight, 0, (interval - 5), 1, 0) * 255;
      } else if (focusState == 1) {
        targetAlpha = map(distToHighlight, 0, (interval - 5), 1, 0.6) * 255;
      }
      alphas[i] = lerp(alphas[i], targetAlpha, 0.03);
      fill(alphas[i]);
      text(copy.charAt(i), 0, 0);
      translate(characterWidth, 0);
    }
    popMatrix();
  }
}