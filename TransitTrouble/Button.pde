/*************************************
 * Button Class 
 * Superclass for Clickable Buttons
 *************************************/

public class Button {
  
  private int _x, _y;
  private int _size, _detectRadius;
  private color _c;
  
  public Button( int x, int y, int size, int detectRadius, color c ) {    
    _x = x;
    _y = y;
    _size = size;
    _detectRadius = detectRadius; 
    _c = c;
  }
  
  public boolean isMouseNear() {
    return distPointToPoint(_x, _y, mouseX, mouseY) > _detectRadius;
  }
  
  public float distPointToPoint( int x1, int y1, int x2, int y2 ) {
    return sqrt( pow(x1-x2, 2) + pow(y1-y2, 2) );
  }
  
  
  public void update() {
    pushMatrix();
    fill(_c);
    stroke(0);
    ellipse( _x, _y, _size, _size ); //draw button
    popMatrix();
  }
  
}