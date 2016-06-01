/*************************************
 * Station Class
 * Contains a queue for Persons to enter a Train
 *************************************/

import java.util.PriorityQueue;

PriorityQueue<Person> _line = new PriorityQueue<Person>();

public class Station {
  // =======================================
  // Instance Variables
  // =======================================
  private int _shape; // (0 to 6);
  private float _x;
  private float _y;
  
  // =======================================
  // Default Constructor
  // Creates a station bounded by xmin, xmax, ymin and ymax.
  // =======================================
  public Station(float xmin, float ymin, float xmax, float ymax) {
    _shape = int(random(7)); // To adjust depending on time
    _x = xmin + random(xmax - xmin);
    _y = ymin + random(ymax - ymin);
    // System.out.println(_shape); // Debugging
  }
  
  void update() {
    // drawShapes.drawStation(_x, _y, _shape);
    ellipse(_x,_y,10,10);
  }
}