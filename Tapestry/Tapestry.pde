
import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;

SceneManager sceneManager;

void setup () {
  size(800, 600, P3D);
  background(0);
  ortho();
  noStroke();

  sceneManager = new SceneManager().init();
}

void draw () {
  sceneManager.update();
  sceneManager.render();
}

void keyReleased () {
  if (key == ' ') {
    sceneManager.togglePause();
  }
}

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

class Scene {
  String id = "blank";
  int life = 0;

  Scene () {}

  Scene init () {
    life = 0;
    return this;
  }

  void update () {
    life ++;
  }

  void render () {
    background(0);
  }

  void kill () {
    println("killing scene:", id);
  }
}

class PeopleScene extends Scene {
  ArrayList<PImage> photos;
  color[] colors;
  ArrayList<Portrait> portraits;
  float portraitWidth = 120;
  float portraitHeight = 160;

  PeopleScene () {
    id = "people";
    String[] colorsCSV = loadStrings("./colors.txt");
    colors = new color[colorsCSV.length];
    for (int i = 0; i < colorsCSV.length; i++) {
      String c = colorsCSV[i];
      colors[i] = color(unhex("FF" + c.substring(1)));
    }

    photos = new ArrayList();
    String dataFolderPath = dataPath("");
    File directory = new File(dataFolderPath + "/complete-photos");
    File[] listOfSubDirectories = directory.listFiles();
    for (int i = 0; i < listOfSubDirectories.length; i++) {
      if (!listOfSubDirectories[i].isFile()) {
        File subDirectory = listOfSubDirectories[i];
        File[] listOfPictures = subDirectory.listFiles();
        for (int j = 0; j < listOfPictures.length; j++) {
          File picture = listOfPictures[j];
          String portraitPath = dataFolderPath + "/complete-photos/" + subDirectory.getName() + "/" + picture.getName();
          photos.add(loadImage(portraitPath));
        }
      }
    }
  }

  PeopleScene init () {
    super.init();
    println("init people scene");
    int x = 0;
    int y = 0;
    portraits = new ArrayList();
    for (PImage photo : photos) {
      int colorIndex = (int(y + x * 4) % colors.length);
      Portrait portrait = new Portrait().init(this, photo, portraitWidth, portraitHeight, x, y, colors[colorIndex]);
      portraits.add(portrait);
      y ++;
      if (y > 4) {
        x ++;
        y = 0;
      }
    }
    return this;
  }

  void update () {
    super.update();
    for (Portrait portrait : portraits) {
      portrait.update();
    }
  }

  void render () {
    super.render();
    pushMatrix();
    translate(width/2.0, height/2.0);
    for (Portrait portrait : portraits) {
      portrait.render();
    }
    popMatrix();
  }
}



class Portrait {
  Scene scene;
  PImage img;
  float w = 0;
  float h = 0;
  int x = 0;
  int y = 0;
  int status = 0;
  float angle = TWO_PI;
  float tAngle = TWO_PI;
  color col;
  float[] thresholds = new float[4];

  Portrait () {}

  Portrait init (Scene _scene, PImage _img, float _w, float _h, int _x, int _y, color c) {
    scene = _scene;
    img = _img;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    thresholds[0] = 100;
    thresholds[1] = 500;
    thresholds[2] = 1000;
    thresholds[3] = 1500;

    col = c;
    return this;
  }

  void update () {
    if (status == 0 && scene.life > thresholds[0]) {
        status = 1;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!1", w, h, x, y);
    }
    if (status == 1 && scene.life > thresholds[1]+1) {
        status = 2;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!2", w, h, x, y);
    }    
    if (status == 2 && scene.life > thresholds[2]+2) {
        status = 3;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!3", w, h, x, y);
    }    
    if (status == 3 && scene.life > thresholds[3]+3) {
        status = 4;
        angle = PI;
        tAngle = TWO_PI;
        println("ok!4", w, h, x, y);
    }    
    angle = lerp(angle, tAngle,0.05);
  }

  void render () {
    if (status == 1) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);          
      rotateY(PI);
      translate(0,0,1);
      fill(0);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 2) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      // tint(col);
      image(img,-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }    
    if (status == 3) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(col);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      // tint(col);
      image(img,-w/2.0,0,w,h);   
      popMatrix();
    }    
    if (status == 4) {
      pushMatrix();
      translate(90-width/2.0+x*(w+30)+30+w/2.0, 140-height/2.0+30+y*(h+30));
      rotateY(angle);
      fill(0);
      rect(-w/2.0,0,w,h);
      rotateY(PI);
      translate(0,0,1);
      fill(col);
      rect(-w/2.0,0,w,h);
      popMatrix();
    }
  }
}








