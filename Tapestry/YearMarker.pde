class YearMarker {

  int year;
  PVector pos;
  PVector tpos;
  PFont bodyFont;
  float fontSize;
  boolean active = false;

  float alpha = 0;
  float tAlpha = 1;

  float xOffset;
  

  YearMarker () {}

  YearMarker init (int _year, PVector _pos, float _fontSize, PFont _bodyFont) {
    year = _year;
    pos = _pos.copy();
    tpos = _pos.copy();
    fontSize = _fontSize;
    bodyFont = _bodyFont;
    alpha = 0;
    tAlpha = 1;

    xOffset = 0;
    return this;
  }

  void update (int currentYear) {
    pos.lerp(tpos, 0.12);
    if (!active && currentYear == year) {
      active = true;
    }
    if (active && currentYear != year) {
      active = false;
    }
    alpha = lerp(alpha, tAlpha, 0.1);
  }

  void render () {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    translate(xOffset, 0, 0);
    rotate(-PI / 2);
    textFont(bodyFont, fontSize);
    fill(#F6BC45, alpha * 255);
    textAlign(RIGHT);
    text(year, 0, 0);
    textAlign(LEFT);
    popMatrix();
  }
}
