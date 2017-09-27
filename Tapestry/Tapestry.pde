
/*
  PORTRAITS
  POSTERS
  EVENTS
    data
    layout
    labels
  NOUN PHRASES
  SEARCHLIGHT
  CREDITS
    data
  GLOBE
  MISC
    140 offset to the top
    intro/outro
    scene sequencing
*/

import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.util.Collections;

SceneManager sceneManager;
boolean development = true;
float scaleFactor = 1;

void settings () {
  scaleFactor = development ? 3 : 1;
  size(int(3840 / scaleFactor), int(1080 / scaleFactor), P3D);
}


void setup () {
  background(0);
  ortho();
  noStroke();
  float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);

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



