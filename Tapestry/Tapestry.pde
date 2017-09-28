
/*
  MISC
    
    check unicode
    // black wallpaper
    // export app?
  POSTER
    alpha
  CREDITS
    time per year based on number of projects
    full angle rotation
    trigger offset and origin
    timing
    relayout based on project width
  EVENTS
    data
    layout
  NOUN PHRASES
    titles disappear
  SEARCHLIGHT
    // optimize
    // marker blending
  FILMS
    // data
    // layout
    // sequence
  INTRODUCTION

  
  SCRIPT
    module
    spotlight
    blank
    session
    module
    thank you
    spotlight
    blank
    spotlight
    module

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
    fullScreen(P3D);
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

  if (frameCount == 1) {
    fill(#FF0000);
    ellipse(0,height,50,50);
  }

  float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
  perspective(PI/(3.0), width/height, cameraZ/10.0, cameraZ*10.0);
  fill(!development ? 0 : 10);
  rect(0, 0, screenWidth, screenGutter / scaleFactor);

}

void keyReleased () {
  if (key == 'n') {
    sceneManager.nextScene();
  }
  if (key == 'r') {
    sceneManager.resetScene();
  }

  if (key == '1') {
    sceneManager.transitionToNextScene("module");
  }

  if (key == '2') {
    sceneManager.transitionToNextScene("spotlight");
  }

  if (key == '3') {
    sceneManager.transitionToNextScene("blank");
  }

  if (key == '4') {
    sceneManager.transitionToNextScene("nouns");
  }

  if (key == '5') {
    sceneManager.transitionToNextScene("thanks");
  }
}

void movieEvent(Movie m) {
  m.read();
}