/*
*/

class NounPhrasesScene extends Scene {

  String copy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
  ArrayList<NounPhrase> nounPhrases;
  PFont bodyFont;
  float fontSize = screenWidth / 80;

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
  }

  NounPhrasesScene init () {
    super.init();
    println("init nouns scene");

    ArrayList<JSONObject> allProjects = new ArrayList<JSONObject>();
    for (int i = 0; i < projectsJSON.size(); i++) {
      if (i != 19 && i != 28 && i != 32) {
        allProjects.add((JSONObject) projectsJSON.get(i));
      }
    }

    textFont(bodyFont, fontSize);
    float lineHeight = textAscent() + textDescent();
    float characterWidth = textWidth("a");
    float maxCharacterNumber = ceil((ceil(screenHeight / lineHeight) * (ceil(screenWidth / characterWidth) + 40)) * 0.9);
    println("max", maxCharacterNumber);

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

      ArrayList<String> copyList = new ArrayList();
      JSONArray projectNounPhrasesJSON = projectJSON.getJSONArray("nounphrases");
      
      for (int i = 0; i < projectNounPhrasesJSON.size(); i++) {
        String copy = projectNounPhrasesJSON.getString(i);
        if (!copyList.contains(copy)) {
          copyList.add(copy);
          NounPhrase nounPhrase = new NounPhrase().init(this, copy.toUpperCase(), fontSize, false);
          nounPhrases.add(nounPhrase);
          project.add(nounPhrase);
          characterNumber += copy.length() + 1;
        }
      } 
    }

    Collections.shuffle(nounPhrases);

    ArrayList<NounPhrase> nounPhrasesBucket = (ArrayList<NounPhrase>) nounPhrases.clone();

    float y = 0;
    float x = -characterWidth * floor(random(12));
    int errorCount = 0;
    while (nounPhrasesBucket.size() > 0) {
      NounPhrase nounPhrase = nounPhrasesBucket.get(floor(random(nounPhrasesBucket.size())));
      if (errorCount > 1000 || !nounPhrase.isProjectTitle || (y > 0 && y < floor(screenHeight / lineHeight) && x > 0 && x < floor(screenWidth / characterWidth))) {
        // println("setting position");
        nounPhrase.setPosition(x, y);
        x += (nounPhrase.copy.length() + 1) * characterWidth;
        if (x > screenWidth ) {
          x = -characterWidth * floor(random(12));
          y += lineHeight;
        }
        nounPhrasesBucket.remove(nounPhrase);
      } else {
        errorCount ++;
        // println("layout error:", errorCount);
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
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective();
    super.render();
    blendMode(BLEND);
    pushMatrix();
    for (NounPhrase nounPhrase : nounPhrases) {
      nounPhrase.render();
    }
    popMatrix();
  }

}