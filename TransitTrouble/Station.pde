/*************************************
 * Station Class
 * Contains a queue for Persons to enter a Train
 *************************************/

import java.util.PriorityQueue;

public class Station {
  // =======================================
  // Instance Variables
  // =======================================
  private int _shape; // (0 to 6);
  private int _x;
  private int _y;
  private int _gridX;
  private int _gridY;
  private PriorityQueue<Person> _line;
  private TrainLine _trainLine;
  
  // =======================================
  // Default Constructor
  // Creates a station on the lattice grid of Map.
  // =======================================
  public Station(int[] coords) {
    _shape = 0; // To adjust depending on time
    _x = coords[0];
    _y = coords[1];
    _gridX = coords[2];
    _gridY = coords[3];
    _line = new PriorityQueue<Person>();
    _trainLine = null;
    // println(_shape, _x, _y, _gridX, _gridY); // Debugging
  }
    
  // =======================================
  // Mutators and Accessors
  // ======================================= 
  /** getX 
   * returns x location of station **/
  int getX() {
    return _x;
  }
  /** getGridX 
   * returns x location of station on grid **/
  int getGridX() {
    return _gridX;
  }
  
  /** getY
   * returns y location of station **/
  int getY() {
    return _y; 
  }
  /** getGridY 
   * returns y location of station on grid **/
  int getGridY() {
    return _gridY;
  }
  
  /** setX
   * sets x location of station on map **/
  int setX(int newX) {
    int oldX = _x;
    _x = newX;
    return oldX; 
  }
  /** setY
   * sets y location of station on map **/
  int setY(int newY) {
    int oldY = _y;
    _y = newY;
    return oldY; 
  }
  
  void setTrainLine(TrainLine tl){
    _trainLine = tl;
  }
  
  TrainLine getTrainLine(){
    return _trainLine;
  }
 
  void recalc(int[] coords){
    _x = coords[0];
    _y = coords[1];
  } 
   
  // =======================================
  // Drawing Station
  // =======================================
  void update() {
    drawStation(_x, _y, _shape);
  }
}