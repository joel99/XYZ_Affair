//DRAWING HELPER FUNCTIONS
void drawStation(int x, int y, int shapeID){
  fill(255);
  stroke(0);
  strokeWeight(3);
  int r = width / (map.maxX - map.minX) / 5;
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