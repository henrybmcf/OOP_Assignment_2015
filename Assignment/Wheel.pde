class Wheel
{
  PVector pos;
  int segments;
  float diameter;

  Wheel()
  {
    this(width * 0.367f, height  * 0.321f, 220, 6);
  }

  Wheel(float x, float y, float diameter, int segments)
  {
    pos = new PVector(x, y);
    this.diameter = diameter;
    this.segments = segments;
    theta = TWO_PI / segments;
    thetaBase = HALF_PI;
  }

  void render()
  {
    fill(255);
    textAlign(RIGHT);
    textSize(30);
    text("Graphical visualisations of\nTour de France data,\n1950 to 2015.", width - 20, 100);
    
    stroke(100); 
    for (int i = 0; i < segments; i++)
    {
      fill(0);
      strokeWeight(5);
      if((int)option == i)
        fill(255);  
      arc(pos.x, pos.y, diameter, diameter, thetaBase + (theta * i), thetaBase + (theta * i) + theta, PIE);
    }
    
    fill(255);
    strokeWeight(3);
    textAlign(LEFT, CENTER);
    textSize(20);
    if(option != 0)
      text("Option Select: " + ((int)option + 1), pos.x, pos.y + diameter * 0.7f);
    else
      text("Option Select: " + ((int)option), pos.x, pos.y + diameter * 0.7f);
    
    textAlign(LEFT);
    text("Option List", 60, height - 220);
    textSize(17);
    text("1 = Speed trend graph\n2 = Stages pie chart\n3 = Record stage wins bubble graph\n4 = Correlation graph, speed, stages and lengths", 60, height - 170);
  }

  void update()
  {   
    if (keyPressed)
    {
      if (keyCode == LEFT || keyCode == RIGHT)
      {
        option = (HALF_PI - thetaBase) / theta;
        if (option < 1)
            option += 6;
        if (option > 6)
            option -= 6;
      }

      // Turn wheel depending on arrow key pressed
      if (keyCode == LEFT)
      {
        thetaBase -= 0.04f;
        if(thetaBase <= 0.0f)
           thetaBase = TWO_PI;
      }
      if (keyCode == RIGHT)
      {
        thetaBase += 0.04f;
        if (thetaBase >= TWO_PI)
            thetaBase = 0.0f;
      }

      // Go to menu option when return key pressed
      if (key == RETURN || key == ENTER)
        menu = (int) option + 1;
    }
  }
}