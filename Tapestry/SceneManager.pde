
class SceneManager {
  HashMap<String, Scene> sceneMap;
  Scene currentScene = null;
  boolean paused = false;
  String lastSceneId = "searchlight";
  String[] sceneIds = {"people", "nouns", "searchlight", "posters"};

  SceneManager () {}

  SceneManager init () {
    sceneMap = new HashMap<String, Scene>();

    Scene blankScene = new Scene();
    PeopleScene peopleScene = new PeopleScene();
    NounPhrasesScene nounPhrasesScene = new NounPhrasesScene();
    SearchlightScene searchlightScene = new SearchlightScene();
    PostersScene postersScene = new PostersScene();

    sceneMap.put("blank", blankScene);
    sceneMap.put("people", peopleScene);
    sceneMap.put("nouns", nounPhrasesScene);
    sceneMap.put("searchlight", searchlightScene);
    sceneMap.put("posters", postersScene);
    
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
    currentScene = sceneMap.get(sceneIds[(Arrays.asList(sceneIds).indexOf(lastSceneId) + 1) % (sceneIds.length + 1)]);
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective(PI/(3.0), width/height, cameraZ/10.0, cameraZ*10.0);
    currentScene.init();
  }

  void resetScene () {
    currentScene.kill();
    currentScene.init();
  }
}