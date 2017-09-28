
class SceneManager {
  HashMap<String, Scene> sceneMap;
  Scene currentScene = null;
  boolean paused = false;
  String lastSceneId;
  String[] sceneIds = {"people", "nouns", "searchlight", "posters", "credits"};

  String nextSceneId = "";
  int nextSceneTimer = -1;


  SceneManager () {
    lastSceneId = !development ? "blank" : "credits";
  }

  SceneManager init (PApplet sketch) {
    sceneMap = new HashMap<String, Scene>();

    Scene blankScene = new Scene();
    ModuleScene moduleScene = new ModuleScene(sketch);
    ThankYouScene thankYouScene = new ThankYouScene(sketch);
    SpotlightScene spotlightScene = new SpotlightScene();

    PeopleScene peopleScene = new PeopleScene();
    NounPhrasesScene nounPhrasesScene = new NounPhrasesScene();
    SearchlightScene searchlightScene = new SearchlightScene();
    PostersScene postersScene = new PostersScene();
    CreditsScene creditsScene = new CreditsScene();

    // IntroductionScene introductionScene = new IntroductionScene(sketch);
    // TypewriterScene typewriterScene = new TypewriterScene();

    sceneMap.put("blank", blankScene);
    sceneMap.put("module", moduleScene);
    sceneMap.put("thanks", thankYouScene);
    sceneMap.put("spotlight", spotlightScene);

    sceneMap.put("people", peopleScene);
    sceneMap.put("nouns", nounPhrasesScene);
    sceneMap.put("searchlight", searchlightScene);
    sceneMap.put("posters", postersScene);
    sceneMap.put("credits", creditsScene);
    // sceneMap.put("intro", introductionScene);
    // sceneMap.put("typewriter", typewriterScene);
    
    currentScene = sceneMap.get(lastSceneId);
    currentScene.init();
    return this;
  }

  void update () {
    if (currentScene != null) {
      currentScene.update();
    }
    if (nextSceneTimer > -1) {
      if (nextSceneTimer == 0 && nextSceneId != null) {
        sceneManager.currentScene.kill();
        sceneManager.currentScene = sceneManager.sceneMap.get(nextSceneId);
        sceneManager.currentScene.init();
        nextSceneId = null;
      }      
      nextSceneTimer --;
    }
  }

  void render () {
    if (currentScene != null) {
      currentScene.render();
    }
  }


  void nextScene () {
    String newId = currentScene.id;
    while (newId == currentScene.id) {
      newId = sceneIds[floor(random(sceneIds.length))];
    }
    println("next scene will be", newId);
    transitionToNextScene(newId);
  }

  void nextScene (boolean instant) {
    String newId = currentScene.id;
    while (newId == currentScene.id) {
      newId = sceneIds[floor(random(sceneIds.length))];
    }
    println("next scene will be", newId);
    if (!instant) {
      transitionToNextScene(newId);
    } else {
      currentScene.kill();
      currentScene = sceneMap.get(newId);
      currentScene.init();
      nextSceneId = null;
      nextSceneTimer = -1;
    }
  }

  void resetScene () {
    currentScene.kill();
    currentScene.init();
  }  

  void transitionToNextScene (String id) {
    if (currentScene.id == "blank") {
      currentScene.kill();
      currentScene = sceneMap.get(id);
      currentScene.init();
      nextSceneId = null;
      nextSceneTimer = -1;
    } else {
      currentScene.fadeOut();
      nextSceneId = id;
      nextSceneTimer = 100;
    }
  }

  // void togglePause () {
  //   println("toggle pause");
  //   paused = !paused;
  //   if (paused && currentScene.id != "blank") {
  //     lastSceneId = currentScene.id;
  //     currentScene.kill();
  //     currentScene = sceneMap.get("blank");
  //     println("init blank scene");
  //     currentScene.init();
  //   } else if (!paused && currentScene.id == "blank"){
  //     currentScene.kill();
  //     currentScene = sceneMap.get(lastSceneId);
  //     currentScene.init();
  //   }
  // }
}











