
class SearchlightScene extends Scene {

  PFont bodyFont;
  float fontSize = screenWidth / 50;
  ArrayList<Segment> segments;
  ArrayList<PVector> waypoints;
  float speed = 1;
  float waypointCursor = 0;
  PVector pos = new PVector();

  ArrayList<Marker> markers;
  float markerSpawnInterval = 20;
  float markerSpeed = 2;

  float turnInterval; 

  JSONArray projectsJSON;

  PImage[] modules;

  String projectCopy;

  boolean fadingOut;

  SearchlightScene () {
    id = "searchlight";
    bodyFont = loadFont("RubikMonoOne-Regular-72.vlw");
    projectsJSON = loadJSONArray("projects.json");

    modules = new PImage[4];
    modules[0] = loadImage("modules/pink_dot.png");
    modules[1] = loadImage("modules/pink_square_.png");
    // modules[2] = loadImage("modules/pink_square_dot.png");
    modules[2] = loadImage("modules/yellow_square_.png");
    modules[3] = loadImage("modules/yellow_square_dot.png");
  }

  SearchlightScene init () {
    super.init();
    println("init searchlight scene");

    fadingOut = false;

    int projectId = -1;
    while (projectId == -1 || projectId == 19 || projectId == 28 || projectId == 32) {
      projectId = floor(random(projectsJSON.size()));
    }

    JSONObject project = (JSONObject) projectsJSON.get(projectId);
    projectCopy = project.getString("description");

    waypoints = new ArrayList<PVector>();
    textFont(bodyFont, fontSize);
    segments = new ArrayList();
    
    turnInterval = floor(3 + sq(random(1)) * 5);
    String[] words = split(projectCopy, ' ');
    ArrayList<String> phrases = new ArrayList();
    String seg = "";
    for (String w : words) {
      seg += w + " ";
      turnInterval --;
      if (turnInterval == 0) {
        phrases.add(seg);
        seg = "";
        turnInterval = floor(3 + sq(random(1)) * 5);
      }
    }

    float theta = 0;
    PVector cursor = new PVector();
    for (String p : phrases) {
      Segment segment = new Segment().init(this, p, fontSize, cursor.x, cursor.y, theta);
      segments.add(segment);
      float thetaOffset = (random(1) < 0.5 ? 1 : -1) * PI / 2;
      if (theta <= -PI / 2) thetaOffset = PI / 2;
      if (theta >= PI / 2) thetaOffset = -PI / 2;
      float segmentWidth = textWidth(p + " ");
      cursor.add(new PVector(cos(theta) * segmentWidth, sin(theta) * segmentWidth));
      theta += thetaOffset;
      waypoints.add(segment.absolutePos[0]);
    }
    waypoints.add(segments.get(segments.size() - 1).absolutePos[1]);

    waypointCursor = 0;
    perspective();
    imageMode(CENTER);

    markers = new ArrayList();


    return this;
  }

  void update () {
    super.update();
    for (Segment segment : segments) {
      segment.update();
    }

    float cursorOffset = waypointCursor;
    for (int i = 0; i < waypoints.size() - 1; i++) {

      if (i == waypoints.size() - 2 && !done) {
        done = true;
        sceneManager.nextScene();
      }

      PVector v1 = waypoints.get(i);
      PVector v2 = waypoints.get(i + 1);
      float dist = PVector.dist(v1, v2);
      if (cursorOffset - dist <= 0) {
        float alpha = cursorOffset / dist;
        pos = v1.copy().lerp(v2, alpha);
        cursorOffset = 0;
        break;
      } else {
        cursorOffset -= dist;
      }
    }
    if (cursorOffset > 0) {
      println("scene done.");
      sceneManager.resetScene();
    }
    waypointCursor += speed;

    if (!fadingOut) {
      if (markerSpawnInterval == 0) {
        PImage texture = markers.size() == 0 ? modules[0] : modules[floor(random(modules.length))];
        Marker marker = new Marker().init(this, waypoints, markerSpeed, texture);
        markers.add(marker);
        markerSpawnInterval = int(150 + random(100));
      }   
      markerSpawnInterval --; 
    }

    for (int i = 0; i < markers.size(); i++) {
      Marker marker = markers.get(i);
      marker.update();
      if (!marker.active) {
        markers.remove(i);
        i --;
      }
    }

    if (life > maxLifespan && !done) {
      done = true;
      sceneManager.nextScene();
    }
  }

  void render () {
    float cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    perspective();
    super.render();
    background(0);
    pushMatrix();
    translate(screenWidth / 2.0 + 20, screenHeight / 2.0);
    translate(-pos.x, -pos.y);

    blendMode(ADD);
    for (Marker marker : markers) {
      marker.render();
    }

    blendMode(BLEND);
    for (Segment segment : segments) {
      segment.render();
    }
    popMatrix();
  }

  void fadeOut () {
    fadingOut = true;
    for (Marker marker : markers) {
      marker.ts = 0;
    }
    for (Segment segment : segments) {
      segment.tAlpha = 0;
    }
  }

}