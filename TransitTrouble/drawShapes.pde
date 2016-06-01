//DRAWING HELPER FUNCTIONS
void drawStation(int x, int y, int shapeID){
  fill(255);
  stroke(0);
  switch(shapeID){
  case 1:
    drawCircle(x, y, 10, true);
    break;
  case 2:
    drawTriangle(x, y, 10, true);
    break;
  case 3:
    drawSquare(x, y, 10, true);
    break;    
  }
}

void drawPerson(int x, int y, int shapeID){

}

//SHAPES IN ORDER (Add more)
//[circle,triangle,square,pentagon,hexagon,arrow,star]

//isStation is true if drawing station, false if drawing passenger
void drawCircle(int x, int y, int r, boolean isStation){
  if (isStation){
  
  }
  else {
  
  }
}

void drawTriangle(int x, int y, int r, boolean isStation){
  if (isStation){
  
  }
  else {
  
  }
}

void drawSquare(int x, int y, int r, boolean isStation){
  if (isStation){
  
  }
  else {
  
  }
}





//Polygon generation code from processing API
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}