/*************************************
 * TrainLine Class 
 * Collection of Stations joined together to form a train line.
 *************************************/

public class TrainLine {
  // =======================================
  // Instance Variables
  // =======================================
  ArrayList<Station> _stations;
  ArrayList<Connector> _connectors;
  Terminal _tStart;
  Terminal _tEnd;
  color c;

  // =======================================
  // Default Constructor
  // Creates a TrainLine. 
  // =======================================
  public TrainLine(Connector con) {
    _stations = new ArrayList<Station>();
    _connectors = new ArrayList<Connector>();
    _connectors.add(con);
    _stations.add(con.getStart());
    _stations.add(con.getEnd());
    _tStart = new Terminal(con.getStart(), con);
    _tEnd = new Terminal(con.getEnd(), con);

    c = color(int(random(255)), int(random(255)), int(random(255)));
  }

  // =======================================
  // TrainLine Methods
  // =======================================
  //two types of adding - terminus adding and end line adding.
  /** addStation(Station s)
   * Adds station to the TrainLine
   * precond: Station exists
   * postcond: _stations includes the new station **/
  //generic case, base case

  //in general
  void addTerminal(Station s, Station sNew){
    if (s == _stations.get(0)){
       _connectors.add(0, new Connector(sNew, s)); 
       _stations.add(0, sNew);
       _tStart = new Terminal(_connectors.get(0).getStart(), _connectors.get(0));
    }
    else {
      _connectors.add(new Connector(s, sNew));
      _stations.add(sNew);
      _tEnd = new Terminal(_connectors.get(_connectors.size() - 1).getEnd(), _connectors.get(_connectors.size() - 1));
    }
  }
  
  void addTerminal(Station s){
    addTerminal(_stations.get(_stations.size() - 1), s);
  }
  
  /*
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
  */
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
  void recalc(){
    for (Connector c: _connectors){
      c.recalc();
    }
    _tStart.recalc();
    _tEnd.recalc();
  }
  
  void update() {
    //draw terminals
    _tStart.update();
    _tEnd.update();

    //draw the rest.
    for (int i = 0; i < _connectors.size(); i++) {
      _connectors.get(i).update();
    }
    for (int i = 0; i < _stations.size(); i++) {
      _stations.get(i).update();
    }
  }
}