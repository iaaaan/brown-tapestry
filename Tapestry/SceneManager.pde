class SceneManager {
  HashMap<String, Scene> sceneMap;
  Scene currentScene = null;
  boolean paused = false;
  String lastSceneId = "people";

  SceneManager () {}

  SceneManager init () {
    sceneMap = new HashMap<String, Scene>();
    PeopleScene peopleScene = new PeopleScene();
    Scene blankScene = new Scene();
    sceneMap.put("blank", blankScene);
    sceneMap.put("people", peopleScene);
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
    paused = !paused;
    if (paused && currentScene.id != "blank") {
      lastSceneId = currentScene.id;
      currentScene.kill();
      currentScene = sceneMap.get("blank");
      println("init blank scene");
      currentScene.init();
    }
    if (!paused && currentScene.id == "blank") {
      currentScene.kill();
      currentScene = sceneMap.get(lastSceneId);
      currentScene.init();
    }
  }
}