/*************************************
 * TrainLine Class 
 * Collection of Stations joined together to form a train line.
 *************************************/

public class TrainLine {
  // =======================================
  // Instance Variables
  // =======================================
  ArrayList<Station> _stations;
  //corresponding list of tuples of draggables for _stations to track double ends.
  ArrayList<Pair> _stationEnds; 
  //ArrayList<Connector> _connectors;
  Terminal _tStart;
  Terminal _tEnd;
  color c;

  // =======================================
  // Default Constructor
  // Creates a TrainLine. 
  // =======================================
  public TrainLine(Station s) {
    _stations = new ArrayList<Station>();
    _stationEnds = new ArrayList<Pair>();
    _stations.add(s);
    _tStart = new Terminal(s, this);
    _tEnd = new Terminal(s, this);
    _stationEnds.add(new Pair(_tStart, _tEnd));
    _tEnd.calcXY();
    c = color(int(random(255)), int(random(255)), int(random(255)));
  }

  //test method
  public Station getStation(int i){
    return _stations.get(i);
  }

  public ArrayList<Pair> getStationEnds(){
    return _stationEnds;
  }

  // =======================================
  // TrainLine Methods
  // =======================================
  //two types of adding - terminus adding and mid-line adding.
  /** addStation(Station s)
   * Adds station to the TrainLine
   * precond: Station exists
   * postcond: _stations includes the new station **/
  //generic case, base case

  //in general

  //addTerminal - adds to either end, adjusting _stations and _stationEnds
  void addTerminal(Station s, Station sNew) {
    if (_stations.size() == 1) {
      //it doesn't matterrr have the thing recalc, wlog use tEnd for this new station
      Connector c= new Connector(s, sNew, this);
      //update stations
      _stations.add(sNew);
      _tEnd = new Terminal(sNew, this);

      //we now have two stations.
      //update stationEnds
      _stationEnds.set(0, new Pair(_tStart, c));
      _stationEnds.add(new Pair(c, _tEnd));
      //this is a problem.
    } else {
      //println("hmm");
      int end; //either 0 or size - 1 (slightly more compact method of coding)
      //first check whichever end to retain.
      if (s == _stations.get(0)) {
        end = 0;
        _tStart = new Terminal(sNew, this);
      } else {// repeat of above, but s is now the other end
        end = _stationEnds.size() - 1;
        _tEnd = new Terminal(sNew, this);
      }
      //println("hmm2 " + end);
      Connector c = new Connector(sNew, s, this);
      _stations.add(end, sNew);
      Pair temp = _stationEnds.get(end);

      //if else block adjusts old end
      if (temp.getA() instanceof Terminal) {
        _stationEnds.set(end, new Pair(c, temp.getB()));
      } else {//getB() is terminal
        _stationEnds.set(end, new Pair(temp.getA(), c));
      }

      //load in new end - I have to check again
      if (end == 0)
        _stationEnds.add(end, new Pair(_tStart, c));
      else 
      _stationEnds.add(new Pair(c, _tEnd));
    }
  }

  Draggable getOtherEnd(Station s, Draggable d){
    if (_stationEnds.size() > 0 && _stations.indexOf(s) != -1) {
      Pair temp = _stationEnds.get(_stations.indexOf(s));
      return temp.getOther(d);
    }
    return null;
  }

  Terminal[] getTerminals() {
    return new Terminal[]{_tStart, _tEnd};
  }
  
  public color getColor(){
    return c;
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
  void recalc() {
    for (Pair p : _stationEnds) {
      p.getA().recalc();
      
    }
    _tStart.recalc();
    _tEnd.recalc();
  }

  void update() {
    //draw terminals
    _tStart.update();
    _tEnd.update();
    //draw the rest.
    for (int i = 1; i < _stationEnds.size(); i++) {
      _stationEnds.get(i).getA().update();
    }
    for (int i = 0; i < _stations.size(); i++) {
      _stations.get(i).update();
    }
  }
}