class PostersScene extends Scene {
  ArrayList<PImage> photos;
  color[] colors;
  ArrayList<Poster> posters;
  float posterWidth = width / 14.4;
  float posterHeight = width / 6.75;

  PostersScene () {
    id = "posters";
    String[] colorsCSV = loadStrings("./colors.txt");
    colors = new color[colorsCSV.length];
    for (int i = 0; i < colorsCSV.length; i++) {
      String c = colorsCSV[i];
      colors[i] = color(unhex("FF" + c.substring(1)));
    }

    photos = new ArrayList();
    String dataFolderPath = dataPath("");
    File directory = new File(dataFolderPath + "/posters");
    File[] listOfSubDirectories = directory.listFiles();
    for (int i = 0; i < listOfSubDirectories.length; i++) {
      if (!listOfSubDirectories[i].isFile()) {
        File subDirectory = listOfSubDirectories[i];
        File[] listOfPictures = subDirectory.listFiles();
        for (int j = 0; j < listOfPictures.length; j++) {
          File picture = listOfPictures[j];
            try {
              String posterPath = dataFolderPath + "/posters/" + subDirectory.getName() + "/" + picture.getName();
              PImage photo = loadImage(posterPath);
              photos.add(photo);
            } catch (Exception e) {}
        }
      }
    }
  }

  PostersScene init () {
    super.init();
    println("init posters scene");
    int x = 0;
    int y = 0;
    int k = 0;
    posters = new ArrayList();
    int horizontalCount = photos.size();
    int verticalCount = 1;
    for (PImage photo : photos) {
      int colorIndex = (k % colors.length);
      Poster poster = new Poster().init(this, photo, posterWidth, posterHeight, x, y, colors[colorIndex], horizontalCount, verticalCount);
      posters.add(poster);
      x ++;
      k ++;
    }
    // ortho();
    // perspective();
    float fovFactor = 3;
    float cameraZ = (height/2.0) / tan(PI*8.5 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective(PI/(3.0 * fovFactor), width/height, cameraZ/10.0, cameraZ*10.0);
    imageMode(CORNER);
    return this;
  }

  void update () {
    super.update();
    for (Poster poster : posters) {
      poster.update();
    }
  }

  void render () {
    super.render();
    pushMatrix();
    translate(width/2.0, height/2.0);
    for (Poster poster : posters) {
      poster.render();
    }
    popMatrix();
  }
}