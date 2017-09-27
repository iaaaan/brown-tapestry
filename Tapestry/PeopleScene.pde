class PeopleScene extends Scene {
  ArrayList<PImage> photos;
  color[] colors;
  ArrayList<Portrait> portraits;
  float portraitWidth = screenWidth / 40;
  float portraitHeight = screenWidth / 30;

  PeopleScene () {
    id = "people";

    gutterX = 0;
    gutterY = screenWidth / 18;
    margin = screenWidth / 140;


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
            try {
              String portraitPath = dataFolderPath + "/complete-photos/" + subDirectory.getName() + "/" + picture.getName();
              
              int colorIndex = (k % colors.length);
              color col = colors[colorIndex];
              PImage photo = loadImage(portraitPath);
              PGraphics pg = createGraphics(int(portraitWidth), int(portraitHeight));
              pg.beginDraw();
              pg.noStroke();
              pg.image(photo, 0, 0, portraitWidth, portraitHeight);
              pg.filter(GRAY);
              pg.blendMode(HARD_LIGHT);
              pg.fill(col, 90);
              if (abs(brightness(col) - 140) > 70) {
                pg.blendMode(OVERLAY);
                pg.fill(col, 50);
              }
              pg.rect(0, 0, portraitWidth, portraitHeight);
              pg.blendMode(BLEND);
              pg.fill(col, 50);
              pg.rect(0, 0, portraitWidth, portraitHeight);
              pg.endDraw();
              PImage tintedPhoto = pg.get();
              photos.add(tintedPhoto);
              k ++;
            } catch (Exception e) {}
        }
      }
    }
  }

  PeopleScene init () {
    super.init();
    // noiseDetail(6, 0.5);
    println("init people scene");
    int x = 0;
    int y = 0;
    int k = 0;
    portraits = new ArrayList();
    int horizontalCount = ceil(photos.size() / 5);
    int verticalCount = 5;
    for (PImage photo : photos) {
      int colorIndex = (k % colors.length);
      Portrait portrait = new Portrait().init(this, photo, portraitWidth, portraitHeight, x, y, colors[colorIndex], horizontalCount, verticalCount);
      portraits.add(portrait);
      y ++;
      if (y > 4) {
        x ++;
        y = 0;
      }
      k ++;
    }
    // ortho();
    // default value is PI * 30.0
    
    imageMode(CORNER);
    return this;
  }

  void update () {
    super.update();
    for (Portrait portrait : portraits) {
      portrait.update();
    }
  }

  void render () {
    float fovFactor = 3;
    float cameraZ = (height/2.0) / tan(PI*8.5 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective(PI/(3.0 * fovFactor), width/height, cameraZ/10.0, cameraZ*10.0);
    super.render();
    pushMatrix();
    translate(screenWidth/2.0, screenHeight/2.0);
    for (Portrait portrait : portraits) {
      portrait.render();
    }
    popMatrix();
  }
}