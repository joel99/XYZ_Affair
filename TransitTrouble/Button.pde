/*************************************
 * Button Class 
 * Superclass for Clickable Buttons
 *************************************/

public class Button {
  
  boolean isActive;
  int _x, _y;
  int _size, _detectRadius;
  color _c;
  
  public Button( int x, int y, int size, int detectRadius, color c ) {    
    _x = x;
    _y = y;
    _size = size;
    _detectRadius = detectRadius;   
    _c = c;
  }
  
  public boolean isClicked() {
    if (mousePressed && distPointToPoint(_x, _y, mouseX, mouseY) < _detectRadius) {
      activate();
      return true;
    }
    return false;
  }
  
  public boolean isPressed() {
    return (mousePressed && distPointToPoint(_x, _y, mouseX, mouseY) < _detectRadius);
  }
  
  public void deactivate(){
    isActive = false;
  }
  
  public void activate(){
    isActive = true;
  }
  
  public float distPointToPoint( int x1, int y1, int x2, int y2 ) {
    return sqrt( pow(x1-x2, 2) + pow(y1-y2, 2) );
  }
  
  
  public void update() {
    fill(_c);
    
    if (isActive) {
      stroke(0);
      strokeWeight(5);
    }
    else noStroke();
    
    ellipse( _x, _y, _size, _size ); //draw button
  }
  
}