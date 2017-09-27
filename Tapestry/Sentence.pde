
class Sentence {
  String copy;
  int charId = 0;
  int charInterval = 1;
  float fontSize;
  boolean drifting = false;
  PVector pos;
  TypewriterScene scene;
  PShape mesh;
  PGraphics pg;
  PFont bodyFont;

  float y;
  float ySpeed;
  float targetYSpeed;
  float r;
  float rSpeed;
  float targetRSpeed;
  float theta;
  float thetaSpeed;
  float targetThetaSpeed;

  Sentence () {}

  Sentence init (TypewriterScene _scene, String _copy, float _fontSize, PFont _bodyFont) {
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    copy = _copy;
    fontSize = _fontSize;
    drifting = false;
    pos = new PVector();
    scene = _scene;
    bodyFont = _bodyFont;
    y = 0;
    ySpeed = 0;
    targetYSpeed = 0;
    r = cameraZ;
    rSpeed = 0;
    targetRSpeed = 0;
    theta = 0;
    thetaSpeed = 0;
    targetThetaSpeed = 0;


    return this;
  }

  void updateActive () {
    charInterval --;
    if (charInterval <= 0) {
      if (charId < copy.length()) {
        charId ++;
        charInterval = 3 + ceil(sq(random(1)) * 15);
      } else {
        mesh = createShape();
        generateShape();
        scene.nextSentence(this);
        drifting = true;
      }
    }
  }

  void renderActive () {
    pushMatrix();
    textSize(fontSize);
    String currentCopy = copy.substring(0, Math.min(copy.length(), charId));
    float w = textWidth(currentCopy);
    fill(255);
    translate(0, 0, -r);
    translate(pos.x, pos.y, pos.z);
    translate(-w / 2, 0);
    text(currentCopy, 0, 0);
    popMatrix();
  }

  void generateShape () {

    float charWidth = textWidth(" ");
    
    pg = createGraphics(ceil(charWidth * copy.length()), ceil(charWidth));
    pg.beginDraw();
    pg.textFont(bodyFont, fontSize);
    pg.fill(255);
    pg.text(copy, 0, charWidth);
    pg.endDraw();
    updateShape();

    targetYSpeed = -sq(random(0.5));
    targetRSpeed = 0.5 + random(1);
    // targetThetaSpeed = PI / (1000 + random(500));
    targetThetaSpeed = PI / (2000 + random(100));
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    r = cameraZ; 
  }

  void updateShape () {
    float charWidth = textWidth(" ");
    PVector[] vertices = new PVector[copy.length() * 4];

    pushMatrix();
    for (int i = 0; i < copy.length(); i++) {
      vertices[i * 4 + 0] = new PVector(
        modelX(0, -charWidth, 0),
        modelY(0, -charWidth, 0),
        modelZ(0, -charWidth, 0)
      );

      vertices[i * 4 + 1] = new PVector(
        modelX(0, 0, 0),
        modelY(0, 0, 0),
        modelZ(0, 0, 0)
      );

      vertices[i * 4 + 2] = new PVector(
        modelX(charWidth, 0, 0),
        modelY(charWidth, 0, 0),
        modelZ(charWidth, 0, 0)
      );

      vertices[i * 4 + 3] = new PVector(
        modelX(charWidth, -charWidth, 0),
        modelY(charWidth, -charWidth, 0),
        modelZ(charWidth, -charWidth, 0)
      );

      translate(charWidth, 0, 0);   
      float rad = 0;
      if (r < screenWidth / 2) {
        rad = 100000;
      } else if (r < screenWidth) {
        rad = map(r, screenWidth / 2, screenWidth, 100000, r);
      } else {
        rad = r;
      }
      rotateY(-asin(charWidth / rad));
    }
    popMatrix();

    mesh.beginShape(QUADS);
    mesh.textureMode(NORMAL);
    mesh.texture(pg.get());
    for (int i = 0; i < copy.length(); i++) {
      mesh.vertex(vertices[i * 4 + 0].x, vertices[i * 4 + 0].y, vertices[i * 4 + 0].z, float(i) / copy.length(), 0);
      mesh.vertex(vertices[i * 4 + 1].x, vertices[i * 4 + 1].y, vertices[i * 4 + 1].z, float(i) / copy.length(), 1);
      mesh.vertex(vertices[i * 4 + 2].x, vertices[i * 4 + 2].y, vertices[i * 4 + 2].z, (i + 1.0) / copy.length(), 1);
      mesh.vertex(vertices[i * 4 + 3].x, vertices[i * 4 + 3].y, vertices[i * 4 + 3].z, (i + 1.0) / copy.length(), 0);   
      // println(vertices[i * 4 + 0].x, vertices[i * 4 + 0].y, vertices[i * 4 + 0].z);
    }
    mesh.endShape();

  }

  void updateDrifting () {
    ySpeed = lerp(ySpeed, targetYSpeed, 0.001);
    rSpeed = lerp(rSpeed, targetRSpeed, 0.05);
    thetaSpeed = lerp(thetaSpeed, targetThetaSpeed, 0.05);
    theta += thetaSpeed;
    r += rSpeed;
    y += ySpeed;
    y = 50;
    updateShape();
  }

  void renderDrifting () {

    // float charWidth = textWidth(" ");
    // float rad = 0;
    // if (r < screenWidth / 4) {
    //   rad = 100000;
    // } else if (r < screenWidth / 2) {
    //   rad = map(r, screenWidth / 4, screenWidth / 2, 100000, r);
    // } else {
    //   rad = r;
    // }

    // pushMatrix();
    // float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    // translate(0, y, cameraZ);
    // rotateY(theta);    
    // translate(0, 0, -r);

    // for (int i = 0; i < copy.length() / 2.0; i++) {
    //   rotateY(asin(charWidth / rad));
    //   translate(-charWidth, 0, 0);
    // }

    // for (int i = 0; i < copy.length(); i++) {
    //   text(copy.charAt(i), 0, 0);
    //   translate(charWidth, 0, 0);   
    //   rotateY(-asin(charWidth / rad));
    // }

    // popMatrix();
  }

  
}