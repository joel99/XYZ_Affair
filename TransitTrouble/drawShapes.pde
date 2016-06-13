/*************************************
 * drawShapes Utility File
 * Contains drawing methods for each of the classes for convenience. Used in update.
 *************************************/

// =======================================
// Stations
// =======================================
void drawStationHealth(int x, int y, float HP) {
  noStroke();
  fill(0, 0, 0, 30);
  int r = width / (map.maxX - map.minX);
  arc(x, y, r, r, 0, HP, PIE);
}

void drawStationLine(int x, int y, PriorityQueue<Person> line) {
  noStroke(); 
  fill(0, 0, 0, 75);
  float r = width / (map.maxX - map.minX) / 5.5; // Radius of Station, ~Diameter of Person
  for (int i = 0; i < line.size(); i++) {
    float drawX = x; 
    float drawY = y;

    drawX += 1.9 * r; // Right side of station
    drawX += 1.15 * r * (i % 6);
    drawY -= 0.55 * r;
    if (i >= 6) // Bottom Row
      drawY += 1.1 * r;
    drawPerson(drawX, drawY, r, 1); // Top Row
  }
}

// =======================================
// People
// =======================================
void drawPerson(float x, float y, float r, int shape) {
  if (shape == 1)
    ellipse(x, y, r, r);
}

// =======================================
// Trains
// =======================================
void drawTrain(float x, float y, color c, int dir) {
  rectMode(CENTER);
  noStroke();
  fill(c);
  
  float theta = atan(0.5);
  float phi = 0;
  float r = width / (map.maxX - map.minX) / 5;
  if (dir == 2 || dir == 8) // 90 degrees
    phi += PI / 2;
  if (dir == 9 || dir == 1) // 45 degrees
    phi += PI / 4;
  if (dir == 7 || dir == 3) // -45 degrees
    phi -= PI / 4;
  float x1 = r * cos(theta + phi);
  float y1 = r * sin(theta + phi);
  float x2 = r * cos(-theta + phi);
  float y2 = r * sin(-theta + phi);
  float x3 = -x1;
  float y3 = -y1;
  float x4 = -x2;
  float y4 = -y2;
  x1 += x; x2 += x; x3 += x; x4 += x;
  y1 += y; y2 += y; y3 += y; y4 += y;
  quad(x1, y1, x2, y2, x3, y3, x4, y4);
}

// =======================================
// General
// =======================================
void drawStation(int x, int y, int shapeID) {
  fill(255);
  stroke(0);
  strokeWeight(2);
  int r = width / (map.maxX - map.minX) / 5; // Radius
  switch(shapeID) {
  case 0:
    ellipse(x, y, 2 * r, 2 * r);
    break;
  case 1:
    polygon(x, y, r, 3);
    break;
  case 2:
    polygon(x, y, r, 4);
    break;
  }
}

//SHAPES IN ORDER (Add more)
//[circle,triangle,square,pentagon,hexagon,arrow,star]
//Polygon generation code from processing API
void polygon(int x, int y, int radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (int a = 0; a < TWO_PI; a += angle) {
    int sx = x + (int)(cos(a) * radius);
    int sy = y + (int)(sin(a) * radius);
    vertex(sx, sy);
  }
  endShape(CLOSE);
}