
class TypewriterScene extends Scene {

  PFont bodyFont;
  float fontSize = width / 50;

  JSONArray projectsJSON;
  ArrayList<Sentence> sentences;
  Sentence currentSentence;
  String[] projectSentences;



  TypewriterScene () {
    id = "typewriter";
    bodyFont = loadFont("RubikMonoOne-Regular-72.vlw");
    projectsJSON = loadJSONArray("projects.json");
  }

  TypewriterScene init () {
    super.init();
    println("init typewriter scene");

    JSONObject project = (JSONObject) projectsJSON.get(floor(random(projectsJSON.size())));
    String projectCopy = project.getString("description");
    projectSentences = RiTa.splitSentences(projectCopy);
    // projectSentences = "test 1"};
    // projectSentences = new String[1];
    // projectSentences[0] = "test";
    sentences = new ArrayList();

    perspective();
    textFont(bodyFont, fontSize);

    String copy = project.getString("title");
    currentSentence = new Sentence().init(this, copy, fontSize, bodyFont);

    return this;
  }

  void nextSentence (Sentence lastSentence) {
    sentences.add(lastSentence);
    currentSentence = new Sentence().init(this, projectSentences[0], fontSize, bodyFont);
    projectSentences = subset(projectSentences, 1);
  }

  void update () {
    super.update();
    if (currentSentence != null) currentSentence.updateActive();
    for (Sentence sentence : sentences) {
      sentence.updateDrifting();
    }
  }

  void render () {
    super.render();
    background(0);
    pushMatrix();
    
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    translate(width / 2.0, height / 2.0, cameraZ);
    blendMode(ADD);

    if (currentSentence != null) currentSentence.renderActive();
    for (Sentence sentence : sentences) {
      sentence.renderDrifting();
    }
    popMatrix();
  }

}