class KinectDepth
{
  void update()
  {
    //background(255);
    
    tracker.track();
    
    if (mode)
    {
      image(kinect.getDepthImage(), 0, 0);
      tracker.display();
    }
  
    PVector v1 = tracker.getPos();
    fill(50, 100, 250, 200);
    noStroke();
    ellipse(v1.x, v1.y, 20, 20);
    PVector v2 = tracker.getLerpedPos();
    fill(100, 250, 50, 200);
    noStroke();
    ellipse(v2.x, v2.y, 20, 20);
    
    rectMode(CORNER);
    rect(100, 100, 200, 200);
    if(v1.x > 100 && v2.x > 100 && v1.y > 100 && v2.y > 100 && v1.x < 300 && v2.x < 300 && v1.y < 300 && v2.y < 300)
    {
       text("MENU", width * 0.5f, height * 0.5f);
       kinectTime++;
       if(kinectTime == 60)
           menu = 1;
    }
    else
    {
       kinectTime = 0;
    }
    
    int t = tracker.getThreshold();
    fill(255);
    textAlign(LEFT);
    text("threshold: " + t + "    " +  "framerate: " + int(frameRate), 10, 500);            
  }
}