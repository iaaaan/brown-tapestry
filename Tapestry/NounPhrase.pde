
class NounPhrase {
  String copy;
  float fontSize;
  Scene scene;
  float interval = 20;
  float[] alphas;
  float speedFactor = 30;
  PVector pos;
  PVector tpos;
  int focusState = 0;
  boolean isProjectTitle = false;

  NounPhrase () {}

  NounPhrase init (Scene _scene, String _copy, float _fontSize, boolean _isProjectTitle) {
    copy = _copy;
    fontSize = _fontSize;
    scene = _scene;
    alphas = new float[copy.length()];
    isProjectTitle = _isProjectTitle;
    return this;
  }

  void setPosition (float x, float y) {
    pos = new PVector(x, y, 0);
    tpos = new PVector(x, y, 0);
  }

  void update () {
    pos.lerp(tpos, 0.1);
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
      if (focusState == 1 && isProjectTitle) {
        fill(#F280B3, alphas[i]);
      }
      text(copy.charAt(i), 0, 0);
      translate(characterWidth, 0);
    }
    popMatrix();
  }
}