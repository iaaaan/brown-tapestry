
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



