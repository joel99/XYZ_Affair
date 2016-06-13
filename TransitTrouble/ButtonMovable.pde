/*************************************
 * ButtonMovable Class 
 * Subclass for Train / (Tentative) Locomotive Buttons in game (that can be clicked and dropped)
 *************************************/

public class ButtonMovable extends Button {
  
  int _quantity; //number of trains stacked up (in stock)
  
  public ButtonMovable( int x, int y, int quantity, int size, int detectRadius, color c ) {
    super(x, y, size, detectRadius, c);
    _quantity = quantity;
  }  
  
  boolean isDragged() {
    return mousePressed;
  }
  
  public void update() {
    
    if (super.isClicked()) {
      stroke(0); 
      strokeWeight(5);
      textSize(30);
    }
    else {
      noStroke();
      textSize(20);
    }
    fill(_c);
    
    ellipse( _x, _y, _size, _size ); //draw button
    
    text( _quantity, _x+_size/2.5, _y-_size/2.5 ); //display quantity on topright of button
    
    fill(255);
    rect(_x - _size/4, _y - _size/6, _size/2, _size/3); //display white train icon
    
  }
    
}