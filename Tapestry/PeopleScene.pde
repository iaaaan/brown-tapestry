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