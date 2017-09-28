
class Project {
  CreditsScene scene;
  PVector pos;
  PVector tpos;
  PVector originOffset;
  int year;
  float projectWidth;
  float projectHeight = random(200);
  boolean foldForward;
  boolean active;

  float alpha;
  float tAlpha;
  float alphaSpeed;
  float theta;
  float tTheta;
  float thetaSpeed;

  int hideTimer = -1;
  int showTimer = -1;

  PFont headlineFont;
  PFont bodyFont;

  String title;
  ArrayList<String> team;

  int lineBreaks = 0;

  float xOffset;
  boolean done;

  Project () {}

  Project init (CreditsScene _scene, PVector _pos, int _year, boolean _foldForward, PFont _headlineFont, PFont _bodyFont, String _title, ArrayList<String> _team, int _lineBreaks, float _projectWidth) {
    pos = _pos.copy();
    tpos = _pos.copy();
    year = _year;
    scene = _scene;
    projectWidth = _projectWidth;
    foldForward = _foldForward;
    originOffset = new PVector(foldForward ? -projectWidth / 2 : projectWidth / 2, 0);
    alpha = 0;
    tAlpha = 0;
    alphaSpeed = 0.15;
    theta = foldForward ? PI / 2 : -PI / 2;
    tTheta = foldForward ? PI / 2 : -PI / 2;
    thetaSpeed = 0.1;
    active = false;

    headlineFont = _headlineFont;
    bodyFont = _bodyFont;

    title = _title;
    team = _team;
    lineBreaks = _lineBreaks;
    
    xOffset = 0;

    done = false;

    return this;
  }

  void show () {
    tAlpha = 1;
    tTheta = 0;
    active = true;
    // xOffset = 0;
    // println("showing", year);
  }

  void hide () {
    tAlpha = 0;
    tTheta = foldForward ? -PI / 2 : PI / 2;   
    active = false; 
    // println("hiding", year);
  }

  void update () {
    pos.lerp(tpos, 0.12);
    alpha = lerp(alpha, tAlpha, 0.12);
    theta = lerp(theta, tTheta, 0.12);
    if (hideTimer >= 0) {
      if (hideTimer == 0) {
        hide();
      }
      hideTimer --;
    }
    if (showTimer >= 0) {
      if (showTimer == 0) {
        show();
      }
      showTimer --;
    }

    // if (alpha > 0.05) {
    //   xOffset -= totalOffset / 700;
    // }
  }

  void render () {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    translate(xOffset, 0, 0);
    translate(originOffset.x, originOffset.y, originOffset.z);
    rotateY(theta);
    translate(-originOffset.x, -originOffset.y, -originOffset.z);

    if (alpha > 0.05) {
      pushMatrix();
      textAlign(LEFT);
      fill(255, alpha * 255);
      textFont(headlineFont, screenWidth / 100);
      textLeading(screenWidth / 80);
      text(title, 0, 0);
      translate(0, (screenWidth / 80) * (2 + lineBreaks), 0);
      textLeading(screenWidth / 100);
      textFont(bodyFont, screenWidth / 100);
      for (String n : team) {
        text(n, 0, 0);
        translate(0, (textAscent() + textDescent()) * 1.5, 0);
      }
      popMatrix();
    }

    popMatrix();
  }
}