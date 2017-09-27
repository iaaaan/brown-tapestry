
/*
  PORTRAITS
  POSTERS
  EVENTS
    data
    layout
    labels
  NOUN PHRASES
    fix missing title
  SEARCHLIGHT
    remove pink on pink module
  CREDITS
    data
  GLOBE
  TYPEWRITER
    curve
  MISC
    140 offset to the top
    intro/outro
    scene sequencing

*/

import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.util.Collections;
import rita.*;
import processing.video.*;


SceneManager sceneManager;
boolean development = true;
float scaleFactor = 1;
int scriptStep = 0;
float gutter = 140;

void settings () {
  scaleFactor = development ? 3 : 1;
  size(int(3840 / scaleFactor), int(1080 / scaleFactor), P3D);
}


void setup () {
  background(0);
  return;
  
}

void draw () {

  if (frameCount == 1) {
    ortho();
    noStroke();
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    sceneManager = new SceneManager().init(this);
    println("SKETCH READY, HAVE FUN");
  }

  sceneManager.update();
  sceneManager.render();

  fill(0);
  rect(0, 0, width, gutter / scaleFactor);
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
  if (key == '1') {
    sceneManager.startIntroduction1();
  }
  if (key == '2') {
    sceneManager.resumeIntroduction1();
  }
  if (key == '3') {
    sceneManager.startViz();
  }
  if (key == '4') {
    sceneManager.startIntroduction2();
  }
  if (key == '5') {
    sceneManager.startViz();
  }
  if (key == '0') {
    switch (scriptStep) {
      case 0:
        scriptStep ++;
        sceneManager.startIntroduction1();
        break;
      case 1:
        sceneManager.resumeIntroduction1();
        scriptStep ++;
        break;
      case 2:
        sceneManager.startViz();
        scriptStep ++;
        break;
      case 3:
        sceneManager.startIntroduction2();
        scriptStep ++;
        break;
      case 4:
        sceneManager.startViz();
        scriptStep ++;
        break;
      default:
        break;
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}



