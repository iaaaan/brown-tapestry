class YearMarker {

  int year;
  PVector pos;
  PVector tpos;
  PFont bodyFont;
  float fontSize;
  boolean active = false;
  

  YearMarker () {}

  YearMarker init (int _year, PVector _pos, float _fontSize, PFont _bodyFont) {
    year = _year;
    pos = _pos.copy();
    tpos = _pos.copy();
    fontSize = _fontSize;
    bodyFont = _bodyFont;
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
  }

  void render () {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    textFont(bodyFont, fontSize);
    fill(active ? 255 : 100);
    textAlign(CENTER);
    text(year, 0, 0);
    textAlign(LEFT);
    popMatrix();
  }
}
