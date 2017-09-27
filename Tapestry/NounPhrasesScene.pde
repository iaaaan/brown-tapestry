/*
*/

class NounPhrasesScene extends Scene {

  String copy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
  ArrayList<NounPhrase> nounPhrases;
  PFont bodyFont;
  float fontSize = width / 80;

  ArrayList<ArrayList<NounPhrase>> projects;

  // HashMap<Integer, ArrayList<NounPhrase>> projects;
  // int projectCount = 20;
  int stepCount = 0;
  int focusProjectIndex = -1;

  JSONArray projectsJSON;

  NounPhrasesScene () {
    id = "nouns";
    bodyFont = loadFont("InputMono-Medium-72.vlw");

    projectsJSON = loadJSONArray("projects.json");
    
    

    // ArrayList<ArrayList<NounPhrase>> projects


  }

  NounPhrasesScene init () {
    super.init();
    println("init nouns scene");

    ArrayList<JSONObject> allProjects = new ArrayList<JSONObject>();
    for (int i = 0; i < projectsJSON.size(); i++) {
      allProjects.add((JSONObject) projectsJSON.get(i));
    }

    textFont(bodyFont, fontSize);
    float lineHeight = textAscent() + textDescent();
    float characterWidth = textWidth("a");
    float maxCharacterNumber = ceil((ceil(height / lineHeight) * (ceil(width / characterWidth) + 40)) * 1);

    projects = new ArrayList<ArrayList<NounPhrase>>();
    nounPhrases = new ArrayList();
    int characterNumber = 0;
    while (characterNumber < maxCharacterNumber && projects.size() < allProjects.size()) {
      int id = floor(random(allProjects.size()));
      JSONObject projectJSON = allProjects.get(id);
      ArrayList<NounPhrase> project = new ArrayList<NounPhrase>();
      projects.add(project);

      String titleCopy = projectJSON.getString("title");
      NounPhrase titleNounPhrase = new NounPhrase().init(this, titleCopy.toUpperCase(), fontSize, true);
      nounPhrases.add(titleNounPhrase);
      project.add(titleNounPhrase);
      characterNumber += titleCopy.length();

      JSONArray projectNounPhrasesJSON = projectJSON.getJSONArray("nounphrases");
      for (int i = 0; i < projectNounPhrasesJSON.size(); i++) {
        String copy = projectNounPhrasesJSON.getString(i);
        NounPhrase nounPhrase = new NounPhrase().init(this, copy.toUpperCase(), fontSize, false);
        nounPhrases.add(nounPhrase);
        project.add(nounPhrase);
        characterNumber += copy.length() + 1;
      }
    }

    Collections.shuffle(nounPhrases);
    float x = -characterWidth * random(20);
    float y = 0;
    for (NounPhrase nounPhrase : nounPhrases) {
      nounPhrase.setPosition(x, y);
      x += (nounPhrase.copy.length() + 1) * characterWidth;
      if (x > width ) {
        x = -characterWidth * floor(random(20));
        y += lineHeight;
      }
    }

    stepCount = 60 * 8;
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
          n.tpos.z = -15;
        }
        focusProjectIndex = floor(random(projects.size()));
        ArrayList<NounPhrase> project = projects.get(focusProjectIndex);
        for (NounPhrase n : project) {
          n.focusState = 1;
          n.tpos.z = 0;
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