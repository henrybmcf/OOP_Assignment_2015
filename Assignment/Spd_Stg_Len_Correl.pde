class Spd_Stg_Len_Correl
{
  float xBorder, yBorder;
  float graphWindowRange, vertGraphWindowRange;
  float graphWidth, graphHeight;
  int verticalIntervals, verticalStageIntervals;
  float dataGaps, stageDataGaps;
  float tickSize;
  float lineWidth;
  float horizInterval;
  float highestSpeed, lowestSpeed;
  int longLength, shortLength;
  int highStage, lowStage;
  color lengthColour, speedColour, stagesColour;
  int speedTime, stageTime, lengthTime;
  int speedIndex, stageIndex, lengthIndex;
  
  float average;
 
  Spd_Stg_Len_Correl()
  {
    xBorder = width * 0.1f;
    yBorder = height * 0.1f;
    graphWindowRange = width - xBorder;
    vertGraphWindowRange = height - yBorder;
    graphWidth = width - (xBorder * 2.0f);
    graphHeight = height - (yBorder * 2.0f);
    tickSize = xBorder * 0.1f;
    verticalIntervals = 10;
    dataGaps = graphHeight / verticalIntervals;
    verticalStageIntervals = 5;
    stageDataGaps = graphHeight / verticalStageIntervals; 
    speedColour = color(0, 255, 255);
    lengthColour = color(255, 255, 0);
    stagesColour = color(255, 0, 255);
    rectMode(CENTER);
    speedTime = 3;
    stageTime = 3;
    lengthTime = 3;
    speedIndex = 1;
    stageIndex = 1;
    lengthIndex = 1;
  }

  void render()
  { 
    // Find lowest & highest for mapping
    highestSpeed = speedList.max();//Collections.max(speedList);
    lowestSpeed = speedList.min();//Collections.min(speedList);
    highStage = Collections.max(stages);
    lowStage = Collections.min(stages);
    longLength = Collections.max(lengths);
    shortLength = Collections.min(lengths);
    
    lineWidth = graphWidth / (speedList.size() - 1);
    
    // Speed Graph
    if(correlation[0])
    {
      strokeWeight(3);
      drawAxis(verticalIntervals, dataGaps, "Speed", speedColour, (highestSpeed - lowestSpeed), lowestSpeed);
      
      // Timing drawing graph animation
      if(speedTime > 3)
      {
        if(speedIndex < speedList.size())
            speedIndex++;
        speedTime = 0;
      }
      for(int j = 1; j < speedIndex; j++)
            drawGraph(j, 0, speedList, lowestSpeed, highestSpeed);
      speedTime++;
    }
    
    // Stages Graph
    if(correlation[1])
    {      
      strokeWeight(3);
      stroke(stagesColour);
      line(graphWindowRange, yBorder, graphWindowRange, vertGraphWindowRange);
      drawAxis(verticalStageIntervals, stageDataGaps, "Stages", stagesColour, 0, lowStage);
      // Convert stage arraylist to float in order to pass to drawGraph method
      FloatList List = new FloatList();
      for(int i:stages)
          List.append(float(i));
          
      // Timing drawing graph animation
      if(stageTime > 3)
      {
        if(stageIndex < stages.size())
            stageIndex++;
        stageTime = 0;
      }
      for(int j = 1; j < stageIndex; j++)
            drawGraph(j, 1, List, lowStage, highStage);
      stageTime++;
    }
    
    // Length Graph
    if(correlation[2])
    {  
      strokeWeight(4);
      drawAxis(verticalIntervals, dataGaps, "Length", lengthColour, longLength - shortLength, shortLength);
      // Convert stage arraylist to float in order to pass to drawGraph method
      FloatList List = new FloatList(); 
      for(int i:lengths)
          List.append(float(i));
      
      // Timing drawing graph animation
      if(lengthTime > 3)
      {
        if(lengthIndex < lengths.size())
            lengthIndex++;
        lengthTime = 0;
      }
      for(int j = 1; j < lengthIndex; j++)
            drawGraph(j, 2, List, shortLength, longLength);
      lengthTime++;
    }

    // Speed & Length Axis
    stroke(speedColour);
    strokeWeight(3);
    line(xBorder, yBorder, xBorder, vertGraphWindowRange);
    for(int i = 0; i <= verticalIntervals; i++)
        line(xBorder - tickSize, vertGraphWindowRange - (i * dataGaps), xBorder, vertGraphWindowRange - (i * dataGaps));   
  
    // X Axis (Year Axis)
    drawYearAxis();
    displayYearInfo(1);
  }
  
  void drawYearAxis()
  {
    stroke(255);
    fill(255);
    strokeWeight(2);
    line(xBorder, vertGraphWindowRange, graphWindowRange, vertGraphWindowRange);    
    horizInterval = graphWidth / (yearList.size() - 1);
    for(int i = 0; i < yearList.size(); i += 5)
    {     
      float x = xBorder + (i * horizInterval);
      line(x, vertGraphWindowRange, x, vertGraphWindowRange + tickSize);
      float textY = height - (yBorder * 0.5f);
      textAlign(CENTER, CENTER);
      text(yearList.get(i), x, textY);
    }
  }
  
  // Draw vertical Axis'
  void drawAxis(int intervals, float windowGap, String graph, color axisColour, float range, float low)
  {
    stroke(axisColour);
    fill(axisColour);
    float axisLabel = 0.0f;
    float dataGap;
    for(int i = 0; i <= intervals; i++)
    {
      float y = vertGraphWindowRange - (i * windowGap);
      if(graph == "Stages")
      {
        line(graphWindowRange + tickSize, y, graphWindowRange, y);
        axisLabel = i + low;
        textAlign(LEFT, CENTER);  
        text(int(axisLabel), graphWindowRange + (tickSize * 2.0f), y);
      }   
      if(graph == "Speed" || graph == "Length")
      {
        if(graph == "Length")
           if(correlation[0])
              y += 20; 
        dataGap = range / verticalIntervals;
        axisLabel = (dataGap * i) + low;
        textAlign(RIGHT, CENTER);  
        text(nf(axisLabel, 2, 2), xBorder - (tickSize * 2.0f), y);
      }
    }
  }
  
  void drawGraph(int i, int ID, FloatList list/*ArrayList<Float> list*/, float low, float high)
  {
    float x1 = xBorder + ((i - 1) * lineWidth);
    float x2 = xBorder + (i * lineWidth);
    float y1 = map(list.get(i - 1), low, high, vertGraphWindowRange, vertGraphWindowRange - graphHeight);
    float y2 = map(list.get(i), low, high, vertGraphWindowRange, vertGraphWindowRange - graphHeight);

    switch(correlationID[ID])
    {
      case "Trend":
        strokeWeight(4);
        line(x1, y1, x2, y2);
        break;
      case "Scatter":
        strokeWeight(1);
        rect(x1, y1, 4, 4);
        break;
      case "scatterTrend":
        strokeWeight(1);
        rect(x1, y1, 4, 4);
        line(x1, y1, x2, y2);
        break;
    }
  }
  
  void displayYearInfo(int sketchID)
  {
    // Determine which year the mouse is in
    int x = (int) ((mouseX - xBorder) / lineWidth);
    float x_coord = xBorder + (x * lineWidth);
    if(x >= 0 && x < years.size())
    {
      // Determine y coordinate of ellipse in relation to line graph
      float speed_y = map(speedList.get(x), lowestSpeed, highestSpeed, vertGraphWindowRange, (vertGraphWindowRange) - graphHeight);
      
      if(sketchID == 1)
      {
        float length_y = map(lengths.get(x), shortLength, longLength, vertGraphWindowRange, (vertGraphWindowRange) - graphHeight);
        // Draw ellipse showing point on length graph
        stroke(0, 0, 255);
        fill(0, 0, 255);
        ellipse(x_coord, length_y, 10, 10);
      }
      
      if(sketchID == 2)
      {
        float avgY = map(average, lowestSpeed, highestSpeed, vertGraphWindowRange, yBorder);
        stroke(255, 0, 0);
        fill(255, 0, 0);
        if(speed_y > avgY)
        {   
          line(x_coord, speed_y, x_coord, vertGraphWindowRange);
          line(x_coord, avgY, x_coord, yBorder);
          stroke(255);
          strokeWeight(4);
          for(int i = 1; i < (speed_y - avgY)/10; i++)
          {
            line(x_coord, avgY + (i * 10), x_coord, avgY + (i * 10) - 5);
          }
        }
        else
        {   
          line(x_coord, speed_y, x_coord, yBorder);    
          line(x_coord, avgY, x_coord, vertGraphWindowRange);
          stroke(255);
          strokeWeight(4);
          for(int i = 1; i < (avgY - speed_y)/10; i++)
              line(x_coord, avgY - (i * 10), x_coord, avgY - (i * 10) + 5);
        }
      }
      
      stroke(255, 0, 0);
      // Draw line to show exact year and speed depending on x coordinates of mouse
      if(sketchID != 2)
      {
          line(x_coord, yBorder, x_coord, vertGraphWindowRange);
          println("Not 2");
      }   
      // Draw ellipse showing point on speed graph
      ellipse(x_coord, speed_y, 10, 10);
      
      
      
      // Display speed and year on relevant side of line, depending on location across graph
      fill(255);
      float text_coordinates;
      if(mouseX < 300)
      {
        textAlign(LEFT, CENTER);
        text_coordinates = x_coord + 10;
      }
      else
      {
        textAlign(RIGHT, CENTER);
        text_coordinates = x_coord - 10;
      }
      float textHeight;
      if(sketchID == 2)
      {
        textHeight = vertGraphWindowRange - 50;
      }
      else
      {
        textHeight = height - 200;
        text("Stages: " + stages.get(x), text_coordinates, textHeight + 40);
        text("Length: " + lengths.get(x) + "Km", text_coordinates, textHeight + 60);
      }
      text("Year: " + years.get(x).tour_year, text_coordinates, textHeight);
      text("Speed: " + speedList.get(x) + " Km/h", text_coordinates, textHeight + 20);
      
      
    }  
  }
}