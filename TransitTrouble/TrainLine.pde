/*************************************
 * TrainLine Class 
 * Collection of Stations joined together to form a train line.
 *************************************/

public class TrainLine {
  // =======================================
  // Instance Variables
  // =======================================
  ArrayList<Station> _stations;
  color c;

  // =======================================
  // Default Constructor
  // Creates a TrainLine. 
  // =======================================
  public TrainLine() {
    _stations = new ArrayList<Station>();
    strokeWeight(5);
    stroke(128, 0, 0); // To Be Changed
    c = color(int(random(255)), int(random(255)), int(random(255)));
  }

  // =======================================
  // TrainLine Methods
  // =======================================
  /** addStation(Station s)
   * Adds station to the TrainLine
   * precond: Station exists
   * postcond: _stations includes the new station **/
   //generic case, base case
  void addStation(Station s) {
    if (_stations.size() > 1) {
      _stations.get(_stations.size() - 1).setEnd(false);
    }
    s.setEnd(true);
    _stations.add(s);
    s.setTrainLine(this);
    
  } 
   //in general
  void addStation(Station s1, Station s2) {
    s1.setEnd(false);
    s2.setEnd(true);
    if (s1.equals(_stations.get(0))) {
      _stations.add(0, s2);
    } else {
      _stations.add(s2);
    }
    s2.setTrainLine(this);
  }

  // =======================================
  // Mutators and Accessors
  // ======================================= 

  //return ends of the lines assuming that size > 0
  Station[] getEnds() {
    return new Station[]{_stations.get(0), _stations.get(_stations.size() - 1)};
  }
  // =======================================
  // Drawing Trainline
  // =======================================
  void update() {
    //declare stroke in connect() because it's used in other places besides update();
    for (int i = 0; i < _stations.size() - 1; i++) {
      connect(_stations.get(i), _stations.get(i+1));
    }
  }

  void connect(Station s1, Station s2) {
    stroke(c);
    int x1, y1, x2, y2, dx, dy, diagx, diagy;
    //we use grid coordinates for simplicity in debugging.
    x1 = s1.getGridX();
    y1 = s1.getGridY();
    x2 = s2.getGridX();
    y2 = s2.getGridY();
    dx = x2 - x1;
    dy = y2 - y1;

    //we only need one line 
    if (dx == 0 || dy == 0 || abs(dx) == abs(dy)) {
      line(s1.getX(), s1.getY(), s2.getX(), s2.getY());
    }
    //we need a diagonal and then a horizontal/vertical
    //calculate the x/y of turning point.
    //requires some casework
    else {
      int m; //slope for line
      if (dx * dy > 0) m = 1;
      else m = -1;

      if (abs(dx) < abs(dy)) {
        diagx = x2;
        //line is y - y1 = m * (x - x1)
        diagy = m * dx + y1;
      } else {
        diagy = y2;
        diagx = dy * m + x1;
      }
      int[] Diag_xy = map.transform(diagx, diagy);
      line(s1.getX(), s1.getY(), Diag_xy[0], Diag_xy[1]);
      line(Diag_xy[0], Diag_xy[1], s2.getX(), s2.getY());
    }
  }
}