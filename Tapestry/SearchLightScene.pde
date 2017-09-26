/*
  speed

*/

class SearchlightScene extends Scene {

  PFont bodyFont;
  float fontSize = width / 300;
  ArrayList<Sentence> sentences;
  ArrayList<PVector> waypoints;
  float speed = 3;
  float waypointCursor = 0;
  PVector pos = new PVector();

  String projectCopy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt scelerisque dolor, ut feugiat justo convallis eu. Suspendisse laoreet erat vitae pellentesque pellentesque. Cras velit lacus, vehicula at metus sodales, pulvinar tincidunt felis. Sed tincidunt consequat nunc, a rutrum metus consectetur sit amet. Mauris consequat quam sem, non ultrices sem faucibus in. Fusce lobortis ante non nisl iaculis, vitae ultrices leo convallis. Ut non mi vitae turpis tincidunt consectetur sed ut odio. Duis sagittis pulvinar diam, eu ullamcorper eros tincidunt in. Sed facilisis id erat non tincidunt. Aliquam commodo, mauris sit amet aliquam mollis, nisi lorem sagittis odio, sit amet blandit ligula sapien et elit.";
  // String projectCopy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt scelerisque dolor, ut feugiat justo convallis eu.";


  SearchlightScene () {
    id = "searchLight";
    bodyFont = loadFont("InputMono-Medium-72.vlw");
  }

  SearchlightScene init () {
    super.init();
    println("init searchlight scene");

    waypoints = new ArrayList<PVector>();
    textFont(bodyFont, fontSize);
    sentences = new ArrayList();
    String[] phrases = split(projectCopy, '.');
    float theta = 0;
    PVector cursor = new PVector();
    for (String p : phrases) {
      p += ".";
      Sentence sentence = new Sentence().init(this, p, fontSize, cursor.x, cursor.y, theta);
      sentences.add(sentence);
      float thetaOffset = (random(1) < 0.5 ? 1 : -1) * PI / 2;
      float sentenceWidth = textWidth(p + " ");
      cursor.add(new PVector(cos(theta) * sentenceWidth, sin(theta) * sentenceWidth));
      theta += thetaOffset;
      waypoints.add(sentence.absolutePos[0]);
    }
    waypoints.add(sentences.get(sentences.size() - 1).absolutePos[1]);

    waypointCursor = 0;
    perspective();

    return this;
  }

  void update () {
    super.update();
    for (Sentence sentence : sentences) {
      sentence.update();
    }

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
      println("scene done.");
      sceneManager.resetScene();
    }

    waypointCursor += speed;
  }

  void render () {
    super.render();
    background(180);
    pushMatrix();
    translate(width / 2.0, height / 2.0);
    translate(-pos.x, -pos.y);

    for (Sentence sentence : sentences) {
      sentence.render();
    }
    popMatrix();
  }

}