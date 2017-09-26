class PeopleScene extends Scene {
  ArrayList<PImage> photos;
  color[] colors;
  ArrayList<Portrait> portraits;
  float portraitWidth = width / 40;
  float portraitHeight = width / 30;

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
    int k = 0;
    for (int i = 0; i < listOfSubDirectories.length; i++) {
      if (!listOfSubDirectories[i].isFile()) {
        File subDirectory = listOfSubDirectories[i];
        File[] listOfPictures = subDirectory.listFiles();
        for (int j = 0; j < listOfPictures.length; j++) {
          File picture = listOfPictures[j];
          String portraitPath = dataFolderPath + "/complete-photos/" + subDirectory.getName() + "/" + picture.getName();
          
          int colorIndex = (k % colors.length);
          color col = colors[colorIndex];
          PImage photo = loadImage(portraitPath);
          PGraphics pg = createGraphics(int(portraitWidth), int(portraitHeight));
          pg.beginDraw();
          pg.image(photo, 0, 0, portraitWidth, portraitHeight);
          pg.filter(GRAY);
          pg.blendMode(HARD_LIGHT);
          pg.fill(col, 180);
          if (abs(brightness(col) - 140) > 70) {
            pg.blendMode(OVERLAY);
            pg.fill(col, 100);
          }
          pg.noStroke();
          pg.rect(0, 0, portraitWidth, portraitHeight);
          pg.endDraw();
          PImage tintedPhoto = pg.get();
          photos.add(tintedPhoto);
          k ++;
        }
      }
    }
  }

  PeopleScene init () {
    super.init();
    println("init people scene");
    int x = 0;
    int y = 0;
    int k = 0;
    portraits = new ArrayList();
    for (PImage photo : photos) {
      int colorIndex = (k % colors.length);
      Portrait portrait = new Portrait().init(this, photo, portraitWidth, portraitHeight, x, y, colors[colorIndex]);
      portraits.add(portrait);
      y ++;
      if (y > 4) {
        x ++;
        y = 0;
      }
      k ++;
    }
    ortho();
    // perspective();
    // camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
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