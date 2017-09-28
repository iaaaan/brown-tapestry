
class SceneManager {
  HashMap<String, Scene> sceneMap;
  Scene currentScene = null;
  boolean paused = false;
  String lastSceneId;
  String[] sceneIds = {"people", "nouns", "searchlight", "posters"};

  SceneManager () {
    lastSceneId = !development ? "blank" : "searchlight";
  }

  SceneManager init (PApplet sketch) {
    sceneMap = new HashMap<String, Scene>();

    Scene blankScene = new Scene();
    PeopleScene peopleScene = new PeopleScene();
    NounPhrasesScene nounPhrasesScene = new NounPhrasesScene();
    SearchlightScene searchlightScene = new SearchlightScene();
    PostersScene postersScene = new PostersScene();
    // TypewriterScene typewriterScene = new TypewriterScene();
    IntroductionScene introductionScene = new IntroductionScene(sketch);

    sceneMap.put("blank", blankScene);
    sceneMap.put("people", peopleScene);
    sceneMap.put("nouns", nounPhrasesScene);
    sceneMap.put("searchlight", searchlightScene);
    sceneMap.put("posters", postersScene);
    // sceneMap.put("typewriter", typewriterScene);
    sceneMap.put("intro", introductionScene);
    
    currentScene = sceneMap.get(lastSceneId);
    currentScene.init();
    return this;
  }

  void update () {
    if (currentScene != null) {
      currentScene.update();
    }
  }

  void render () {
    if (currentScene != null) {
      currentScene.render();
    }
  }

  void togglePause () {
    println("toggle pause");
    paused = !paused;
    if (paused && currentScene.id != "blank") {
      lastSceneId = currentScene.id;
      currentScene.kill();
      currentScene = sceneMap.get("blank");
      println("init blank scene");
      currentScene.init();
    } else if (!paused && currentScene.id == "blank"){
      currentScene.kill();
      currentScene = sceneMap.get(lastSceneId);
      currentScene.init();
    }
  }

  void nextScene () {
    currentScene.kill();
    if (currentScene.id != "blank") {
      lastSceneId = currentScene.id;
    }
    if (lastSceneId == "intro") {
      currentScene = sceneMap.get("blank");
      lastSceneId = "people";
      paused = true;
    } else {
      currentScene = sceneMap.get(sceneIds[(Arrays.asList(sceneIds).indexOf(lastSceneId) + 1) % (sceneIds.length)]);
    }
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective(PI/(3.0), width/height, cameraZ/10.0, cameraZ*10.0);
    currentScene.init();
  }

  void resetScene () {
    currentScene.kill();
    currentScene.init();
  }

  void startIntroduction1 () {
    println("starting introduction 1");
    currentScene.kill();
    currentScene = sceneMap.get("intro");
    ((IntroductionScene) currentScene).init(0);
  }

  void resumeIntroduction1 () {
    if (currentScene.id == "intro") {
      ((IntroductionScene) currentScene).resume();
    }
  }

  void pause () {
    paused = true;
    lastSceneId = currentScene.id;
    currentScene.kill();
    currentScene = sceneMap.get("blank");
    println("init blank scene");
    currentScene.init();
  }

  void startViz () {
    currentScene.kill();
    println("starting viz");
    currentScene = sceneMap.get(sceneIds[floor(random(sceneIds.length))]);
    lastSceneId = currentScene.id;
    currentScene.init();
  }

  void startIntroduction2 () {
    println("starting introduction 2");
    currentScene.kill();
    currentScene = sceneMap.get("intro");
    ((IntroductionScene) currentScene).init(1);
  }

  
}











