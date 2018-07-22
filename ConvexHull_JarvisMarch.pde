ArrayList<PVector> Points = new ArrayList<PVector>();
IntList HullPoints  = new IntList();
boolean ComputeHull = false;

int LeftMost = 0;
PVector LeftMostP = new PVector(0, 0);

PVector AvgPoint = new PVector(0, 0);

int index = 0;
int hullIndex = 0;

float MaxAngle = 0;
int MaxPoint = -1;

void setup()
{
  size(500, 500);
  stroke(255);

  for (int i = 0; i < 500; i++)
  {
    PVector NewP = new PVector(random(500), random(500));
    Points.add(NewP); 
    if (NewP.x <= Points.get(LeftMost).x)
    {
      LeftMost = Points.size()-1;
      HullPoints.set(0, LeftMost);
    }
  }
}


void draw()
{
  background(0);
  stroke(255);
  for (int i = 0; i < Points.size(); i++)
  {
    if (i == HullPoints.get(hullIndex))
    {
      fill(0, 0, 255);
    } else
    {
      fill(255);
    }
    PVector p = Points.get(i);
    ellipse(p.x, p.y, 5, 5);
  }
  stroke(255, 255, 0);
  if (HullPoints.size() > 1)
  {
    for (int i = 1; i < HullPoints.size(); i++)
    {
      PVector p1 = Points.get(HullPoints.get(i-1));
      PVector p2 = Points.get(HullPoints.get(i));
      line(p1.x, p1.y, p2.x, p2.y);
    }
    
  }
  if (MaxPoint >= 0)
    {
      PVector p1 = Points.get(HullPoints.get(HullPoints.size() -1));
      PVector p2 = Points.get(MaxPoint);
      stroke(0, 255, 255);
      line(p1.x, p1.y, p2.x, p2.y);
    }


  if (ComputeHull)
  {
    if (hullIndex == 0)
    {
      PVector PVec = Points.get(HullPoints.get(hullIndex));
      PVector N = new PVector(PVec.x, 0);
      float Angle = CalcAngle(N, Points.get(HullPoints.get(hullIndex)), Points.get(index));
      if (Angle > MaxAngle)
      {
        MaxAngle = Angle;
        MaxPoint = index;
      }
    } else
    {
      PVector Last = Points.get(HullPoints.get(hullIndex-1));
      PVector Now = Points.get(HullPoints.get(hullIndex));
      PVector Test = Points.get(index);

      float Angle = CalcAngle(Last, Now, Test);
      if (Angle > MaxAngle)
      {
        MaxAngle = Angle;
        MaxPoint = index;
      }
    }

    index += 1;
    if (index >= Points.size())
    {
      HullPoints.append(MaxPoint);
      if (HullPoints.get(0) == HullPoints.get(HullPoints.size() -1))
      {
        ComputeHull = false;
      }
      index = 0;
      hullIndex += 1;
      MaxAngle = 0;
      MaxPoint = -1;
    }
  }
}


void mousePressed()
{ 
  if (mouseButton == LEFT)
  {
    PVector NewP = new PVector(mouseX, mouseY);
    Points.add(NewP);
    AvgPoint = new PVector(0, 0);
    for (int i = 0; i < Points.size(); i++)
    {
      AvgPoint.add(Points.get(i));
    }
    AvgPoint = new PVector(AvgPoint.x/Points.size(), AvgPoint.y/Points.size());
    if (NewP.x <= Points.get(LeftMost).x)
    {
      LeftMost = Points.size()-1;
      HullPoints.set(0, LeftMost);
    }
  } else if (mouseButton == RIGHT)
  {
    if (ComputeHull == false)
    {
      LeftMostP = Points.get(LeftMost);
      ComputeHull = true;
      //frameRate(20);
    }
  }
}


float CalcAngle(PVector p3, PVector p1, PVector p2)
{
  float b = dist(p1.x, p1.y, p2.x, p2.y);
  float c = dist(p1.x, p1.y, p3.x, p3.y);
  float a = dist(p3.x, p3.y, p2.x, p2.y);
  //stroke(255, 0, 0);
  //line(p3.x, p3.y, p2.x, p2.y);
  //stroke(0, 255, 0);
  //line(p1.x, p1.y, p3.x, p3.y);
  stroke(0, 0, 255);
  line(p1.x, p1.y, p2.x, p2.y);
  float Top = ComputeTop(a, b, c);
  float Denom = 2 * b * c;
  float Angle = acos(Top/Denom);
  return Angle;
}

float ComputeTop(float a, float b, float c)
{
  float out = 0;
  out += pow(b, 2);
  out += pow(c, 2);
  out -= pow(a, 2);
  return out;
}
