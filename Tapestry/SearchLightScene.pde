/*
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

    // projects = new HashMap<Integer, ArrayList<NounPhrase>>();
    // for (int i = 0; i < projectCount; i ++) {
    //   projects.put(i, new ArrayList<NounPhrase>());
    // }

    // nounPhrases = new ArrayList();
    // textFont(bodyFont, fontSize);
    // float lineHeight = textAscent() + textDescent();
    // float characterWidth = textWidth("a");
    // float x = -characterWidth * random(20);
    // float y = 0;
    // while (y < height) {
    //   while (x < width) {
    //     String c = copy.substring(0, int(10 + random(copy.length() - 10)));
    //     NounPhrase nounPhrase = new NounPhrase().init(this, c.toUpperCase(), fontSize, x, y);
    //     nounPhrases.add(nounPhrase);
    //     projects.get(floor(random(projectCount))).add(nounPhrase);
    //     x += c.length() * characterWidth;
    //   }
    //   x = -characterWidth * floor(random(20));
    //   y += lineHeight;
    // }

    perspective();

    return this;
  }

  void update () {
    super.update();
    for (Sentence sentence : sentences) {
      sentence.update();
    }

    float cursorOffset = waypointCursor;
    for (int i = 0; i < waypoints.size(); i++) {
      PVector v1 = waypoints.get(i);
      if (cursorOffset - v1.mag() <= 0) {
        if (i == waypoints.size() - 1) {
          sceneManager.resetScene();
          break;
        }
        PVector v2 = waypoints.get(i + 1);
        float alpha = cursorOffset / v1.mag();
        pos = v1.copy().lerp(v2, alpha);
        break;
      } else {
        cursorOffset -= v1.mag();
      }
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