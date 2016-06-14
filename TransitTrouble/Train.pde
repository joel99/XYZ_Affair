/*************************************
 * Train Class
 * Object that travels on a TrainLine to various Stations, holds Persons
 *************************************/

import java.util.Stack;

public class Train {
  // =======================================
  // Instance Variables
  // =======================================
  ArrayList<Person> _carriage;
  Connector _connector; // Connector the train will travel on.
  TrainLine _tl; // Trainline this train belongs to.
  Station _start, _end; // Moving from _start to _end
  int _moved;
  int _distance;
  int _midDistance; 
  boolean _docked;
  float _x, _y;
  int time1; // Internal Clock
  int time2; // Internal Clock
  int dir; 

  // =======================================
  // Default Constructor
  // =======================================
  public Train() {
    _tl = activeTrainLine;
    _carriage = new ArrayList<Person>();
    _docked = false;
    dir = 1;
  }
  public Train(Station start, Station end) {
    this();
    _start = start;
    _end = end;
    // Initialize Connector
    _connector = calcConnector(_start, _end);
    //calcConnector();

    // Find Distance Between Stations
    calcDistances();
  }

  public Train(Station start) {
    this();
    _start = start;
    //get a random station to go to;
    Station newStation;
    int i = _tl.indexOf(start);
    if (i == 0) {
      newStation = _tl.getStation(1);
    } else if (i == _tl.getStations().size() - 1) {
      newStation = _tl.getStation(_tl.getStations().size() - 2);
    } else {
      newStation = _tl.getStation(_tl.indexOf(start) + 1);
    }
    _end = newStation;
    _connector = calcConnector(_start, _end);
    calcDistances();
  }

  public Train(int x, int y) {//oh snap
    this();
  }

  // =======================================
  // Methods
  // =======================================
  /** calcDistance() - finds distance between _start and _end Stations
   * precond: _start, _end exist
   * postcond: returns distance (diagonals count as 1) * 100 */
  public int calcDistance() {
    int x1 = _start.getGridX();
    int y1 = _start.getGridY();
    int x2 = _end.getGridX();
    int y2 = _end.getGridY();
    int taxicab = abs(x1 - x2) + abs(y1 - y2);
    int diag = min(abs(x1 - x2), abs(y1 - y2));
    return 100 * (taxicab - diag);
  }

  /** calcMidDistance() - finds distance between _start and midpoint of _connector
   * precond: _start, _connector exist
   * postcond: returns distance (diagonals count as 1) * 100 */
  public int calcMidDistance() {
    if (!_connector.hasMid()) // Connector doesn't have a midpoint
      return 0; 
    int x1 = _start.getGridX();
    int y1 = _start.getGridY();
    int xm = _connector.getMid()[0];
    int ym = _connector.getMid()[1];
    int taxicab = abs(x1 - xm) + abs(y1 - ym);
    int diag = min(abs(x1 - xm), abs(y1 - ym));
    return 100 * (taxicab - diag);
  }

  /** isFull()
   * returns whether the traincar is full */
  public boolean isFull() {
    return _carriage.size() > 5;
  }

  /** calcDirection(x1,y1,x2,y2)
   * Finds direction of pair of points x2,y2 compared to x1,y1
   * precond: x1,y1 and x2,y2 are not the same point
   * postcond: Returns int representing station orientation as follows: 
   * 7 8 9
   * 4 S 6 where S is the first station
   * 1 2 3
   **/
  int calcDirection(int x1, int y1, int x2, int y2) {
    int ret = 0;
    if (y1 >  y2) ret += 0;
    if (y1 == y2) ret += 1;
    if (y1 <  y2) ret += 2;
    ret *= 3;
    if (x1 >  x2) ret += 1;
    if (x1 == x2) ret += 2;
    if (x1 <  x2) ret += 3;
    return ret;
  }

  /** getNextStation() - returns the next station the train should go to
   * precond: _start, _end exist and are part of the same TrainLine
   * postcond: returns the Station the train should make the new end after the train reaches end */
  Station getNextStation() {
    int startIndex = _tl.indexOf(_start);
    int endIndex = _tl.indexOf(_end);
    int newIndex = endIndex + dir;
    if (newIndex < 0 || newIndex >= _tl.size()){
      newIndex -= 2 * dir;
      dir *= -1;
    }
    return _tl.getStation(newIndex);
  }

  /** calcConnector() - finds Connector joining start and end
   * precond: start and end are adjacent Stations
   * postcond: returns the Connector joining the two Stations */
  Connector calcConnector(Station start, Station end) {
    Pair startEnds = _tl.getStationEnds().get(_tl.indexOf(start));
    Pair endEnds = _tl.getStationEnds().get(_tl.indexOf(end));
    Draggable startA = startEnds.getA();
    Draggable startB = startEnds.getB();
    Draggable endA = endEnds.getA();
    Draggable endB = endEnds.getB();

    if (startA == endA || startA == endB)
      return (Connector)startA;
    if (startB == endA || startB == endB)
      return (Connector)startB;
    return null;
  }

  /** hasUnload - checks if there is a person to be unloaded
   * precond: 
   * postcond: returns whether there is a person with the same shape as the Station */
  boolean hasUnload() {
    for (Person p : _carriage) {
      if (p.getShape() == _end.getShape()) 
        return true;
    }
    return false;
  }

  /** getUnload - removes a person from _carriage and unloads it
   * precond: _carriage has someone to unload
   * postcond: Person is removed from _carriage and returned */
  Person getUnload() {
    for (int i = _carriage.size() - 1; i >= 0; i--) {
      if (_carriage.get(i).getShape() == _end.getShape()) {
        score++;
        return _carriage.remove(i);
      }
    }
    return null;
  }

  /** hasLoad - checks if the Station has someone to be loaded
   * precond: 
   * postcond: returns whether there are people to load at the Station */
  boolean hasLoad() {
    return _end.getLineSize() > 0;
  }

  /** getLoad - checks if there is a person to be unloaded
   * precond: 
   * postcond: returns whether there is a person with the same shape as the Station */
  void getLoad() {
    _carriage.add(_end.popLine());
  }

  /* OBSELETE CODE - DELETE LATER 
   void calcConnector() {
   Pair startEnds = _tl.getStationEnds().get(_tl.indexOf(_start));
   Draggable startA = startEnds.getA();
   Draggable startB = startEnds.getB();
   if (startA instanceof Connector) {
   Connector A = (Connector)startA;
   if (A.otherEnd(_start) == _end) {
   _connector = A;
   }
   } else if (startB instanceof Connector) {
   Connector B = (Connector)startB;
   if (B.otherEnd(_start) == _end) {
   _connector = B;
   }
   }
   if (_connector == null) println("SUCKS TO SUCK");
   }
   */

  // =======================================
  // Train Movement and Docking
  // =======================================
  public void move() {
    if (!_docked)
      _moved++;
    if (_moved >= _distance) {
      _docked = true;
    }
    if (_docked && time1 > time2) {
      time2 = time1 + 750; // 0.75 seconds delay
      // Unload Passengers 
      if (hasUnload()) {
        getUnload();
      }
      // Load Passengers 
      else if (hasLoad() && !isFull()) {
        getLoad();
      }
      // Set New Destination
      else {
        Station s = getNextStation();
        _start = _end;
        _end = s;

        // Reset Connector
        _connector = calcConnector(_start, _end);

        // Reset Distances
        calcDistances();

        _docked = false;
      }
    }
  }

  /** calcDistances()
   * updates _moved, _distance, _midDistance depending on _start and _end Stations */
  void calcDistances() {
    _distance = calcDistance();
    _midDistance = calcMidDistance();
    _moved = 0;
  }

  /** recalc()
   * recalculates the map X and map Y of a train, and returns the direction it's heading */
  public int recalc() {
    int startX, startY, endX, endY;
    float percent = _moved * 1.0 / _distance * 1.0;  
    startX = _start.getX();
    startY = _start.getY();
    endX = _end.getX();
    endY = _end.getY();
    if (_midDistance == 0) { // Linear mapping from _start to _end
      percent = _moved * 1.0 / _distance * 1.0;
    } 
    if (_midDistance > 0) {
      if (_moved < _midDistance) { // On Diagonal -- Distance from Start to Mid
        endX = _connector.getTransMid()[0];
        endY = _connector.getTransMid()[1];
        percent = _moved * 1.0 / _midDistance * 1.0;
      } else { // On Horizontal / Vertical -- Distance from Mid to End
        startX = _connector.getTransMid()[0];
        startY = _connector.getTransMid()[1];
        percent = (_moved - _midDistance) * 1.0 / (_distance - _midDistance) * 1.0;
      }
    }
    _x = percent * (endX - startX) + startX;    
    _y = percent * (endY - startY) + startY;
    return calcDirection(startX, startY, endX, endY);
  }

  // =======================================
  // Train Drawing
  // =======================================
  public void update() {
    time1 = millis();
    move();
    drawTrain(_x, _y, _tl.getColor(), recalc());
    fill(0);
    text(_carriage.size(), _x, _y); // Debugging
  }
  public void update(int flag) { // Paused
    int difference = millis() - time1;
    time1 = millis();
    time2 += difference;
    drawTrain(_x, _y, _tl.getColor(), recalc());
    fill(0);
    text(_carriage.size(), _x, _y); // Debugging
  }
}