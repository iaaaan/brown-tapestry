/*

  2012 3 20
  2013 7 29
  2014 5 16
  2015 9 28
  2016 4 21
  2017 12 29

*/

class CreditsScene extends Scene {

  PFont bodyFont;
  PFont headlineFont;
  JSONArray projectsJSON;
  float fontSize = screenWidth / 80;
  int stepInterval = 500;
  int currentYear = 2012;

  float projectWidth = screenWidth / 7;

  ArrayList<Integer> years;
  ArrayList<YearMarker> yearMarkers;
  ArrayList<Project> projects;
  HashMap<Integer, ArrayList<Project>> projectsPerYear;

  CreditsScene () {
    id = "credits";
    bodyFont = loadFont("InputMono-Medium-72.vlw");
    headlineFont = loadFont("RubikMonoOne-Regular-72.vlw");
    projectsJSON = loadJSONArray("projects.json");
  }

  CreditsScene init () {
    super.init();
    println("init people scene");

    currentYear = 2012;

    yearMarkers = new ArrayList();

    HashMap<Integer, ArrayList<JSONObject>> projectsPerYearJSON;
    projectsPerYearJSON = new HashMap();
    years = new ArrayList<Integer>();

    for (int i = 0; i < projectsJSON.size(); i++) {
      JSONObject project = (JSONObject) projectsJSON.get(i);
      int year = parseInt(split(project.getString("year"), '-')[0]);
      if (!projectsPerYearJSON.containsKey(year)) {
        projectsPerYearJSON.put(year, new ArrayList<JSONObject>());
        years.add(year);
      }
      projectsPerYearJSON.get(year).add(project);
    }

    // for (int y : years) {
    int maxProjectsPerYear = 0;

    for (int i = 0; i < years.size(); i++) {
      int y = years.get(i);  
      int peopleCount = 0;
      int projectCount = projectsPerYearJSON.get(y).size();
      if (projectCount > maxProjectsPerYear) {
        maxProjectsPerYear = projectCount;
      }
      for (JSONObject project : projectsPerYearJSON.get(y)) {
         peopleCount += project.getJSONArray("team").size();
      }
      float x = map(i, 0, years.size() - 1, 0, screenWidth / 2.0);
      PVector pos = new PVector(x, screenHeight / 2.0 - 60 / scaleFactor, 0);
      YearMarker yearMarker = new YearMarker().init(y, pos, fontSize, headlineFont);
      yearMarkers.add(yearMarker);
    }

    projectsPerYear = new HashMap();
    for (int i = 0; i < years.size(); i++) {
      int y = years.get(i);
      ArrayList<JSONObject> projectsThisYearJSON = projectsPerYearJSON.get(y);
      ArrayList<Project> projects = new ArrayList();
      projectsPerYear.put(y, projects);
      
      float totalWidth = projectWidth * projectsThisYearJSON.size();
      float missingWidth = Math.max(0, projectWidth * (projectsThisYearJSON.size() + 1) - screenWidth); 
      // println(y, screenWidth, projectWidth * (projectsThisYearJSON.size() + 2), missingWidth);


      float x = projectWidth;
      for (int j = 0; j < projectsThisYearJSON.size(); j++) {
        JSONObject projectJSON = projectsThisYearJSON.get(j);
        // float x = map(j, 0, projectsThisYearJSON.size(), 0, projectWidth * projectsThisYearJSON.size() - 1) - (projectWidth * projectsThisYearJSON.size()) / 2.0;
        // PVector pos = new PVector(x, -screenHeight / 3, 0);
          

        PVector pos = new PVector(x, -screenHeight / 2.75);

        x += projectWidth;


        boolean foldForward = x + projectWidth / 2.0 >= totalWidth / 2.0;
        
        String title = projectJSON.getString("title");


        int lineBreaks = 0;
        if (title.equals("Measuring Public Perception of Stories in the News")){
          title = "Measuring Public\nPerception of\nStories in the News";
          lineBreaks = 2;
        }
        if (title.equals("Personalized Television News")){
          title = "Personalized\nTelevision News";
          println("aga: ", title);
          lineBreaks = 1;
        }
        if (title.equals("Mapping Monuments and Memory")){
          title = "Mapping Monuments\nand Memory";
          lineBreaks = 1;
        }
        if (title.equals("The Declassification Engine")){
          title = "The\nDeclassification\nEngine";
          lineBreaks = 2;
        }
        if (title.equals("Widescope and Synapp")){
          title = "Widescope\nand Synapp";
          lineBreaks = 1;
        }
        if (title.equals("On the Brink of Famine")){
          title = "On the Brink\nof Famine";
          lineBreaks = 1;
        }

        JSONArray teamJSON = projectJSON.getJSONArray("team");
        ArrayList<String> team = new ArrayList();
        for (int k = 0; k < teamJSON.size(); k++) {
          String member = (String) teamJSON.get(k); 
          team.add(member.replaceAll("\\(.*\\)", ""));
        }

        Project project = new Project().init(this, pos, y, projectWidth, foldForward, headlineFont, bodyFont, title, team, lineBreaks, missingWidth);
        projects.add(project);
      }
    }

    for (Project p : projectsPerYear.get(2012)) {
      p.showTimer = 0;
    }

    return this;
  }

  void update () {
    super.update();
    
    stepInterval --;
    if (stepInterval <= 0) {
      for (YearMarker marker : yearMarkers) {
        marker.tpos.x -= (screenWidth / 2.0 / (yearMarkers.size() - 1));
      }
      currentYear ++;
      if (currentYear == 2018) {
        // done
        currentYear = 2012;
        for (YearMarker marker : yearMarkers) {
          marker.tpos.x += (screenWidth / 2.0 / (yearMarkers.size() - 1)) * (yearMarkers.size());
        }
      }
      stepInterval = 700;
    }

    for (YearMarker marker : yearMarkers) {
      marker.update(currentYear);
    }

    for (Integer y : years) {
      ArrayList<Project> projects = projectsPerYear.get(y);
      for (Project p : projects) {
        if (!p.active && p.year == currentYear) {
          p.showTimer = 0;
        }
        if (p.active && p.year != currentYear) {
          p.hideTimer = 0;
        }
        p.update();
      }
    }
  }

  void render () {
    // float fovFactor = 3;
    // float cameraZ = (height/2.0) / tan(PI*8.5 / 180.0);
    // camera(width/2.0, height/2.0, cameraZ, width/2.0, height/2.0, 0, 0, 1, 0);
    // perspective(PI/(3.0 * fovFactor), width/height, cameraZ/10.0, cameraZ*10.0);

    super.render();
    perspective();
    // background(0);
    // blendMode(ADD);
    
    pushMatrix();



    translate(screenWidth / 2.0, screenHeight / 2.0);
    for (YearMarker marker : yearMarkers) {
      marker.render();
    }

    pushMatrix();
    translate(-screenWidth / 2.0, 0, 0);
    
    for (Integer y : years) {
      ArrayList<Project> projects = projectsPerYear.get(y);
      for (Project p : projects) {
        p.render();
      }
    }
    
    popMatrix();

    popMatrix();
    // blendMode(BLEND);
  }
}



