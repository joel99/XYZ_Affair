/*************************************
 * drawShapes Utility File
 * Contains drawing methods for each of the classes for convenience. Used in update.
 *************************************/

// =======================================
// Stations
// =======================================
void drawStationHealth(int x, int y, float HP) {
  noStroke();
  fill(0,0,0,30);
  int r = width / (map.maxX - map.minX);
  arc(x, y, r, r, 0, HP, PIE);
}

void drawStationLine(int x, int y, PriorityQueue<Person> line) {
  noStroke(); 
  fill(0,0,0,60);
  float r = width / (map.maxX - map.minX) / 5.5; // Radius of Station, ~Diameter of Person
  for (int i = 0; i < line.size(); i++) {
    float drawX = x; float drawY = y;
    drawX += 1.5 * r;
    drawX += 1.1 * r * i;
    
    drawY += r;
    if (i > 6) drawY *= -1;
    drawPerson(drawX, drawY, r, 1);
}
}

// =======================================
// People
// =======================================
void drawPerson(float x, float y, float r, int shape) {
  if (shape == 1)
    ellipse(x,y,r,r);
}

// =======================================
// General
// =======================================
void drawStation(int x, int y, int shapeID){
  fill(255);
  stroke(0);
  strokeWeight(2);
  int r = width / (map.maxX - map.minX) / 5; // Radius
  switch(shapeID){
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

//given x, y of station
void drawPerson(int x, int y, int shapeID){

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