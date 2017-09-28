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

  float offsetSpeed = 3 / scaleFactor;

  float projectWidth = screenWidth / 7;

  ArrayList<Integer> years;
  ArrayList<YearMarker> yearMarkers;
  ArrayList<Project> projects;
  // HashMap<Integer, ArrayList<Project>> projectsPerYear;


  boolean fadingOut = false;

  CreditsScene () {
    id = "credits";
    bodyFont = loadFont("InputMono-Medium-72.vlw");
    headlineFont = loadFont("RubikMonoOne-Regular-72.vlw");
    projectsJSON = loadJSONArray("projects.json");
  }

  CreditsScene init () {
    super.init();
    println("init people scene");

    stepInterval = 500;
    currentYear = 2012;
    fadingOut = false;

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

    projects = new ArrayList();
    float x = screenWidth;

    yearMarkers.add(new YearMarker().init(2012, new PVector(x - screenWidth / 50, -screenHeight / 2.3), fontSize, headlineFont));

    for (int i = 0; i < years.size(); i++) {
      int year = years.get(i);
      ArrayList<JSONObject> projectsThisYearJSON = projectsPerYearJSON.get(year);


      for (int j = 0; j < projectsThisYearJSON.size(); j++) {
        JSONObject projectJSON = projectsThisYearJSON.get(j);
        PVector pos = new PVector(x, -screenHeight / 2.5);
        // boolean foldForward = Math.random() < 0.5;
        boolean foldForward = true;
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

        float pWidth = 0;
        textFont(headlineFont, screenWidth / 100);
        text(title, 0, 0);
        if (pWidth < textWidth(title)) pWidth = textWidth(title);
        textFont(bodyFont, screenWidth / 100);
        for (String n : team) {
          if (pWidth < textWidth(n)) pWidth = textWidth(n);
        }

        Project project = new Project().init(this, pos, year, foldForward, headlineFont, bodyFont, title, team, lineBreaks, pWidth);
        projects.add(project);
        // project.showTimer = 0;

        // x += projectWidth;
        x += pWidth + screenWidth / 40;
        if (j == projectsThisYearJSON.size() - 1) {
          x += screenWidth / 10;

          // add year
          if (year + 1 < 2018) {
            PVector yearPos = new PVector(x - screenWidth / 50, -screenHeight / 2.3);
            YearMarker yearMarker = new YearMarker().init(year + 1, yearPos, fontSize, headlineFont);
            yearMarkers.add(yearMarker);
          }
        }
      }
    }

    return this;
  }

  void update () {
    super.update();

    // int lastYear = currentYear;
    // currentYear = 2012;

    int projectsDone = 0;
    for (Project project : projects) {
      project.update();
      project.xOffset -= offsetSpeed;
      if (project.pos.x + project.xOffset <= -project.projectWidth) {
      //   currentYear = project.year;
        projectsDone ++;
      }
      if (project.pos.x + project.xOffset < screenWidth - project.projectWidth && !project.active && !project.done) {
        println("showing", project.title);
        project.active = true;
        project.showTimer = int(random(50));
      }

      // if (project.pos.x + project.xOffset < project.projectWidth && !project.done) {
      //   println("hiding", project.title);
      //   project.done = true;
      //   project.hideTimer = int(random(50));
      // }
    }
    
    for (YearMarker marker : yearMarkers) {
      marker.update(currentYear);
      marker.xOffset -= offsetSpeed;
    }

    // if (lastYear != currentYear && !done) {
    //   for (YearMarker marker : yearMarkers) {
    //     marker.tpos.x -= (screenWidth / 2.0 / (yearMarkers.size() - 1));
    //   }
    // }
    
    if (projectsDone == projects.size() && !done) {
      done = true;
      sceneManager.nextScene(true);
    }

    // if (!done) {
    //   stepInterval --;
    //   if (stepInterval <= 0 && !fadingOut) {
        // for (YearMarker marker : yearMarkers) {
        //   marker.tpos.x -= (screenWidth / 2.0 / (yearMarkers.size() - 1));
        // }
    //     currentYear ++;
    //     if (currentYear == 2018 && !done) {
    //       done = true;
    //       currentYear --;
    //       sceneManager.nextScene();
    //       // marker.tpos.x += (screenWidth / 2.0 / (yearMarkers.size() - 1));
    //     }
    //     stepInterval = 700;
    //   }
    // }


    // for (Integer y : years) {
    //   ArrayList<Project> projects = projectsPerYear.get(y);
    //   for (Project p : projects) {
    //     if (!fadingOut) {
    //       if (!p.active && p.year == currentYear) {
    //         p.showTimer = 0;
    //       }
    //       if (p.active && p.year != currentYear) {
    //         p.hideTimer = 0;
    //       }
    //     }
    //     p.update();
    //   }
    // }
  }

  void render () {

    super.render();
    perspective();

    pushMatrix();

    translate(screenWidth / 2.0, screenHeight / 2.0);

    pushMatrix();
    translate(-screenWidth / 2.0, 0, 0);
    for (YearMarker marker : yearMarkers) {
      marker.render();
    }
    for (Project project : projects) {
      project.render();
    }
    popMatrix();

    popMatrix();
  }

  void fadeOut () {
    println("FADEOUT");
    fadingOut = true;
  }
}



