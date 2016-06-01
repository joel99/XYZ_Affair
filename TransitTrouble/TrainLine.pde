/*************************************
 * TrainLine Class 
 * Collection of Stations joined together to form a train line.
 *************************************/

public class TrainLine {
  // =======================================
  // Instance Variables
  // =======================================
  ArrayList<Station> _stations;
  
  // =======================================
  // Default Constructor
  // Creates a TrainLine. 
  // =======================================
  public TrainLine() {
    _stations = new ArrayList<Station>();
    strokeWeight(5);
    stroke(128,0,0); // To Be Changed
  }
  
  // =======================================
  // TrainLine Methods
  // =======================================
  /** addStation(Station s)
   * Adds station to the TrainLine
   * precond: Station exists
   * postcond: _stations includes the new station **/
  void addStation(Station s) {
    _stations.add(s);
  }
  
  /** getDirection(Station first, Station second)
   * Finds direction of second station with respect to the first
   * precond: Station first and second are not the same station
   * postcond: Returns int representing station orientation as follows: 
   * 7 8 9
   * 4 S 6 where S is the first station
   * 1 2 3
   **/
  int getDirection(Station first, Station second) {
    int x1,y1,x2,y2;
    x1 = first.getX();
    y1 = first.getY();
    x2 = second.getX();
    y2 = second.getY();
    return -1;
  }
  
  // =======================================
  // Mutators and Accessors
  // ======================================= 
  
  // =======================================
  // Drawing Trainline
  // =======================================
  void update() {
    for (int i = 0; i < _stations.size(); i++) {
      ; 
    }
  }
}