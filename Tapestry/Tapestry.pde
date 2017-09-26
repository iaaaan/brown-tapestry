
// 140 offset to the top

import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;

SceneManager sceneManager;
boolean development = true;
float scaleFactor = 1;

void settings () {
  scaleFactor = development ? 3 : 1;
  size(int(3840 / scaleFactor), int(940 / scaleFactor), P3D);
}

void setup () {
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
  if (key == 'n') {
    sceneManager.nextScene();
  }
  if (key == 'r') {
    sceneManager.resetScene();
  }
}



