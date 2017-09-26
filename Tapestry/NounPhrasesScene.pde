/*
*/

class NounPhrasesScene extends Scene {

  String copy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
  ArrayList<NounPhrase> nounPhrases;
  PFont bodyFont;
  float fontSize = width / 80;
  HashMap<Integer, ArrayList<NounPhrase>> projects;
  int projectCount = 20;
  int stepCount = 60 * 8;
  int focusProjectIndex = -1;

  NounPhrasesScene () {
    id = "noun";
    bodyFont = loadFont("InputMono-Medium-72.vlw");
  }

  NounPhrasesScene init () {
    super.init();
    println("init nouns scene");

    projects = new HashMap<Integer, ArrayList<NounPhrase>>();
    for (int i = 0; i < projectCount; i ++) {
      projects.put(i, new ArrayList<NounPhrase>());
    }

    nounPhrases = new ArrayList();
    textFont(bodyFont, fontSize);
    float lineHeight = textAscent() + textDescent();
    float characterWidth = textWidth("a");
    float x = -characterWidth * random(20);
    float y = 0;
    while (y < height) {
      while (x < width) {
        String c = copy.substring(0, int(10 + random(copy.length() - 10)));
        NounPhrase nounPhrase = new NounPhrase().init(this, c.toUpperCase(), fontSize, x, y);
        nounPhrases.add(nounPhrase);
        projects.get(floor(random(projectCount))).add(nounPhrase);
        x += c.length() * characterWidth;
      }
      x = -characterWidth * floor(random(20));
      y += lineHeight;
    }

    perspective();

    return this;
  }

  void update () {
    super.update();
    for (NounPhrase nounPhrase : nounPhrases) {
      nounPhrase.update();
    }

    stepCount --;
    if (stepCount == 0) {
      if (focusProjectIndex == -1) {
        for (NounPhrase n : nounPhrases) {
          n.focusState = -1;
          n.tpos.z = -10;
        }
        focusProjectIndex = floor(random(projectCount));
        ArrayList<NounPhrase> project = projects.get(focusProjectIndex);
        for (NounPhrase n : project) {
          n.focusState = 1;
          n.tpos.z = 10;
        }
      } else {
        focusProjectIndex = -1;
        for (NounPhrase n : nounPhrases) {
          n.focusState = 0;
          n.tpos.z = 0;
        }
      }
      stepCount = 60 * 8;
    }
  }

  void render () {
    super.render();
    pushMatrix();
    for (NounPhrase nounPhrase : nounPhrases) {
      nounPhrase.render();
    }
    popMatrix();
  }

}