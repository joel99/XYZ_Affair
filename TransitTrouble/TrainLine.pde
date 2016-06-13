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

  // =======================================
  // Mutators and Accessors
  // ======================================= 

  //return ends of the lines assuming that size > 0
  Station[] getEnds() {
    return new Station[]{_stations.get(0), _stations.get(_stations.size() - 1)};
  }

  public Station getStation(int i) {
    return _stations.get(i);
  }

  public int indexOf(Station s) {
    return _stations.indexOf(s);
  }

  public ArrayList<Pair> getStationEnds() {
    return _stationEnds;
  }

  public ArrayList<Station> getStations() {
    return _stations;
  }

  public int size() {
    return _stations.size();
  }

  public color getColor() {
    return c;
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
    for (int i = 0; i < _stations.size(); i++) {
      println(_stations.get(i));
    }
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

      if (end == 0) _stations.add(end, sNew);
      else _stations.add(sNew);

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

      for (int i = 0; i < _stations.size(); i++) {
        println(_stations.get(i));
      }
    }
  }

  //precond - s is end station
  void removeTerminalStation(Station s) {
    for (int i = 0; i < _stations.size(); i++) {
      println(_stations.get(i));
    }
    int i = _stations.indexOf(s);  //this should be either 0 or size - 1. use to reduce redundant code
    _stations.remove(i);
    println(i);
    if (i != 0) println("NOT ZERO???");
    Draggable dRemove;
    //find end to remove (end that is not terminal of current end station)
    println(i);//whhy is this twooooosfjslkfjl
    Pair oldEnd = _stationEnds.remove(i);
    if (oldEnd.getA() instanceof Terminal) {
      dRemove = oldEnd.getB();
    } else {
      dRemove = oldEnd.getA();
    }

    //just so indices make sense after removal
    if (i != 0) i--;
    println(i);
    Pair newEnd = _stationEnds.get(i);


    for (int j = 0; j < _stationEnds.size(); j++) println(_stationEnds.get(j) + " : " + _stationEnds.get(j).getA() + " " + _stationEnds.get(j).getB() );
    println("STATION ENDS : " + _stationEnds.size());
    Terminal t = new Terminal(_stations.get(i), this);
    if (i == 0) _tStart = t;
    else _tEnd = t;

    println(newEnd);
    //sets the relevant new end with a terminal
    if (newEnd.getA() == dRemove) {
      println("remove end a");
      //getB is the one we want to keep
      _stationEnds.set(i, new Pair(t, newEnd.getB()));
    } else if (newEnd.getB() == dRemove) {
      println("remove end b");
      _stationEnds.set(i, new Pair(t, newEnd.getA()));
    } else {
      println("huh");
    }
    println("b");
    for (int j = 0; j < _stationEnds.size(); j++) println(_stationEnds.get(j) + " : " + _stationEnds.get(j).getA() + " " + _stationEnds.get(j).getB() );
  }

  Draggable getOtherEnd(Station s, Draggable d) {
    if (_stationEnds.size() > 0 && _stations.indexOf(s) != -1) {
      Pair temp = _stationEnds.get(_stations.indexOf(s));
      return temp.getOther(d);
    }
    return null;
  }

  Terminal[] getTerminals() {
    return new Terminal[]{_tStart, _tEnd};
  }


  /** addStation - Takes two stations, and inserts it into the TrainLine
   * precond: s1, s2 are stations which are joined by the same connector
   * postcond: The stations are connected s1 -- newStation -- s2 */
  void addStation(Station s1, Station s2, Station newStation, Connector parent) {
    println("STATIONS: " + _stations);
    println("STATIONENDS: " + _stationEnds);

    // Connect Stations
    Connector c1 = new Connector(s1, newStation, this); // Between Station 1 and New Station
    Connector c2 = new Connector(newStation, s2, this); // Between Station 2 and New Station
    Pair Pair1 = _stationEnds.get(this.indexOf(s1)); // Station 1's Pair
    Pair Pair2 = _stationEnds.get(this.indexOf(s2)); // Station 2's Pair

    Pair newPairStation = null; // Pair of the new Station

    if (Pair1.getA() == parent) { 
      Pair1.setA(c1);
    }
    if (Pair1.getB() == parent) { 
      Pair1.setB(c1);
    }
    if (Pair2.getA() == parent) { 
      Pair2.setA(c2);
    }
    if (Pair2.getB() == parent) { 
      Pair2.setB(c2);
    }
    newPairStation = new Pair(c1, c2);

    // Add Pair
    _stationEnds.add(max(this.indexOf(s1), this.indexOf(s2)), newPairStation);

    // Add Station
    _stations.add(max(this.indexOf(s1), this.indexOf(s2)), newStation);

    println("STATIONS: " + _stations);
    println("STATIONENDS: " + _stationEnds);
  }

  boolean isAdjacent(Station s1, Station s2) {
    return abs(_stations.indexOf(s1) - _stations.indexOf(s2)) == 1;
  }

  Connector findCommon(Station s1, Station s2) {
    int i1 = _stations.indexOf(s1);
    int i2 = _stations.indexOf(s2);
    if (abs(i1 - i2) != 1) { 
      println("uh oh");
      return null;
    } else {
      Pair p1 = _stationEnds.get(i1);
      Pair p2 = _stationEnds.get(i2);
      if (p1.getA() == p2.getA() || p1.getA() == p2.getB()) return (Connector) p1.getA();
      else return (Connector) p1.getB();
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

  // =======================================
  // Drawing Trainline
  // =======================================
  void recalc() {
    for (Pair p : _stationEnds) {
      p.getA().recalc();
      p.getB().recalc();
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
    for (int i = 0; i < _stationEnds.size(); i++) {
      _stationEnds.get(i).getB().update();
    }
    for (int i = 0; i < _stations.size(); i++) {
      _stations.get(i).update();
    }
  }
}