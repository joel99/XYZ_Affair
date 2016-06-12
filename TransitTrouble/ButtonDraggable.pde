/*************************************
 * ButtonMovable Class 
 * Subclass for Train / (Tentative) Locomotive Buttons in game (that can be clicked and dropped)
 *************************************/

public class ButtonMovable extends Button {
  
  private int _quantity; //number of trains stacked up (in stock)
  private int _x, _y;
  private int _size, _detectRadius;
  private color c;
  
  public ButtonMovable( int x, int y, int quantity, int size, int detectRadius, color c ) {
    super(x, y, size, detectRadius, c);
    _quantity = quantity;
  }  
  
  boolean isDragged() {
    return mousePressed;
  }
  
  
    
}