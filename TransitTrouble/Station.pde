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
  private int _x;
  private int _y;
  
  // =======================================
  // Default Constructor
  // Creates a station bounded by xmin, xmax, ymin and ymax.
  // =======================================
  public Station(int[] coords) {
    _shape = 0; // To adjust depending on time
    _x = coords[0];
    _y = coords[1];
    // System.out.println(_shape); // Debugging
  }
  
  void update() {
    drawStation(_x, _y, _shape);
  }
}