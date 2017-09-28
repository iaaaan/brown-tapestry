
/*
  CREDITS
    data
  HIGHLIGHT STAGE
    scene
    sequence
  EVENTS
    data
    layout
  NOUN PHRASES
    titles disappear
  MISC
    scene sequencing
    add reset sketch input
    intro/outro
    check unicode
    // black wallpaper
    // export app?
  SEARCHLIGHT
    // optimize
    // marker blending
  FILMS
    // data
    // layout
    // sequence
  INTRODUCTION
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
float screenGutter = 140;
float screenWidth;
float screenHeight;

void settings () {
  scaleFactor = development ? 3 : 1;
  if (development) {
    size(int(3840 / scaleFactor), int(1080 / scaleFactor), P3D);    
  } else {
    fullScreen();
  }
}

void setup () {
  background(0);
}

void draw () {
  if (frameCount == 1) {
    screenWidth = width;
    screenHeight = height - screenGutter / scaleFactor;
    ortho();
    noStroke();
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    sceneManager = new SceneManager().init(this);
    println("SKETCH READY, HAVE FUN");
  }

  sceneManager.update();
  pushMatrix();
  translate(0, screenGutter / scaleFactor);
  sceneManager.render();
  popMatrix();

  float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
  perspective(PI/(3.0), width/height, cameraZ/10.0, cameraZ*10.0);
  fill(!development ? 0 : 10);
  rect(0, 0, screenWidth, screenGutter / scaleFactor);
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