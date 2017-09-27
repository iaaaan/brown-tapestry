
class SearchlightScene extends Scene {

  PFont bodyFont;
  float fontSize = width / 50;
  ArrayList<Sentence> sentences;
  ArrayList<PVector> waypoints;
  float speed = 1;
  float waypointCursor = 0;
  PVector pos = new PVector();

  ArrayList<Marker> markers;
  float markerSpawnInterval = 20;
  float markerSpeed = 2;

  float turnInterval; 

  String projectCopy = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt scelerisque dolor, ut feugiat justo convallis eu. Suspendisse laoreet erat vitae pellentesque pellentesque. Cras velit lacus, vehicula at metus sodales, pulvinar tincidunt felis. Sed tincidunt consequat nunc, a rutrum metus consectetur sit amet. Mauris consequat quam sem, non ultrices sem faucibus in. Fusce lobortis ante non nisl iaculis, vitae ultrices leo convallis. Ut non mi vitae turpis tincidunt consectetur sed ut odio. Duis sagittis pulvinar diam, eu ullamcorper eros tincidunt in. Sed facilisis id erat non tincidunt. Aliquam commodo, mauris sit amet aliquam mollis, nisi lorem sagittis odio, sit amet blandit ligula sapien et elit.";

  JSONArray projectsJSON;

  SearchlightScene () {
    id = "searchLight";
    bodyFont = loadFont("RubikMonoOne-Regular-72.vlw");
    projectsJSON = loadJSONArray("projects.json");
  }

  SearchlightScene init () {
    super.init();
    println("init searchlight scene");

    JSONObject project = (JSONObject) projectsJSON.get(floor(random(projectsJSON.size())));
    projectCopy = project.getString("description");

    waypoints = new ArrayList<PVector>();
    textFont(bodyFont, fontSize);
    sentences = new ArrayList();
    
    turnInterval = floor(3 + random(5));
    String[] words = split(projectCopy, ' ');
    ArrayList<String> phrases = new ArrayList();
    String segment = "";
    for (String w : words) {
      segment += w + " ";
      turnInterval --;
      if (turnInterval == 0) {
        phrases.add(segment);
        segment = "";
        turnInterval = floor(3 + random(5));
      }
    }

    float theta = 0;
    PVector cursor = new PVector();
    for (String p : phrases) {
      Sentence sentence = new Sentence().init(this, p, fontSize, cursor.x, cursor.y, theta);
      sentences.add(sentence);
      float thetaOffset = (random(1) < 0.5 ? 1 : -1) * PI / 2;
      if (theta <= -PI / 2) thetaOffset = PI / 2;
      if (theta >= PI / 2) thetaOffset = -PI / 2;
      float sentenceWidth = textWidth(p + " ");
      cursor.add(new PVector(cos(theta) * sentenceWidth, sin(theta) * sentenceWidth));
      theta += thetaOffset;
      waypoints.add(sentence.absolutePos[0]);
    }
    waypoints.add(sentences.get(sentences.size() - 1).absolutePos[1]);

    waypointCursor = 0;
    perspective();

    markers = new ArrayList();


    return this;
  }

  void update () {
    super.update();
    for (Sentence sentence : sentences) {
      sentence.update();
    }

    float cursorOffset = waypointCursor;
    for (int i = 0; i < waypoints.size() - 1; i++) {
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

    if (markerSpawnInterval == 0) {
      Marker marker = new Marker().init(this, waypoints, markerSpeed);
      markers.add(marker);
      markerSpawnInterval = int(150 + random(100));
    }   
    markerSpawnInterval --; 

    for (int i = 0; i < markers.size(); i++) {
      Marker marker = markers.get(i);
      marker.update();
      if (!marker.active) {
        markers.remove(i);
        i --;
      }
    }
  }

  void render () {
    super.render();
    background(0);
    pushMatrix();
    translate(width / 2.0, height / 2.0);
    translate(-pos.x, -pos.y);

    for (Marker marker : markers) {
      marker.render();
    }

    for (Sentence sentence : sentences) {
      sentence.render();
    }
    popMatrix();
  }

}