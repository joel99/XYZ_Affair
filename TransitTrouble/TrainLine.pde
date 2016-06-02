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
    x1 = first.getGridX();
    y1 = first.getGridY();
    x2 = second.getGridX();
    y2 = second.getGridY();
    int ret = 0;
    if (y2 < y1) ret += 2;
    if (y2 == y1) ret += 1;
    ret *= 3;
    if (x2 > x1) ret += 2;
    if (x2 == x1) ret += 1;
    ret += 1;
    return ret;
  }
  
  // =======================================
  // Mutators and Accessors
  // ======================================= 
  
  // =======================================
  // Drawing Trainline
  // =======================================
  void update() {
    Station Station1, Station2;
    for (int i = 0; i < _stations.size() - 1; i++) {
      Station1 = _stations.get(i);
      Station2 = _stations.get(i+1);
      int dir = getDirection(Station1, Station2);
      int x1,y1,x2,y2;
      x1 = Station1.getGridX();
      y1 = Station1.getGridY();
      int diagX = x1;
      int diagY = y1;
      x2 = Station2.getGridX();
      y2 = Station2.getGridY();
      int dx = 0;
      int dy = 0;
      boolean checkX = false;
      boolean checkY = false;
      /* print("Station1 X: " + x1 + "\n" +
            "Station1 Y: " + y1 + "\n" +
            "Station2 X: " + x2 + "\n" +
            "Station2 Y: " + y2 + "\n" +
            "Diagonal X: " + diagX + "\n" +
            "Diagonal Y: " + diagY + "\n" +
            "Direction: " + dir + "\n"); */
      switch (dir) { // start switch
        case 1: 
          dx--;
          dy++;
          checkX = checkY = true;
          break;
        case 2: 
          dy++;
          checkY = true;
          break;
        case 3: 
          dx++;
          dy++;
          checkX = checkY = true;
          break;
        case 4: 
          dx--;
          checkX = true;
          break;
        case 6: 
          dx++;
          checkX = true;
          break;
        case 7: 
          dx--;
          dy--;
          checkX = checkY = true;
          break;
        case 8: 
          dy--;
          checkY = true;
          break;
        case 9: 
          dx++;
          dy--;
          checkX = checkY = true;
          break;
      } // end switch
      while (true) {
        if (checkX && (diagX == x2)) break;
        if (checkY && (diagY == y2)) break;
        diagX += dx; 
        diagY += dy; 
        // New x1, y1 will be the end of the diagonal
      }
      int[] Station1_xy = map.transform(x1,y1);
      int[] Diag_xy = map.transform(diagX, diagY);
      int[] Station2_xy = map.transform(x2,y2);
      line(Station1_xy[0],Station1_xy[1],Diag_xy[0],Diag_xy[1]);
      line(Diag_xy[0],Diag_xy[1],Station2_xy[0],Station2_xy[1]);
    }
  }
}