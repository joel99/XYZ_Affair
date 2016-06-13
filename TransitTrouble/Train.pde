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

  // =======================================
  // Default Constructor
  // =======================================
  public Train(Station start, Station end, TrainLine tl) {
    _carriage = new ArrayList<Person>();
    _start = start; 
    _end = end;
    _tl = tl;
    _docked = false;

    // Initialize Connector
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

    // Find Distance Between Stations
    _distance = calcDistance();
    _midDistance = calcMidDistance();
    _moved = 0;
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

  // =======================================
  // Train Movement and Docking
  // =======================================
  public void move() {
    _moved++;
    if (_moved >= _distance) 
      _docked = true;
    //  SWITCH STUFF HERE
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

    if (_moved < _midDistance) { // On Diagonal -- Distance from Start to Mid
      endX = _connector.getTransMid()[0];
      endY = _connector.getTransMid()[1];
      percent = _moved * 1.0 / _midDistance * 1.0;
    } else { // On Horizontal / Vertical -- Distance from Mid to End
      startX = _connector.getTransMid()[0];
      startY = _connector.getTransMid()[1];
      percent = (_moved - _midDistance) * 1.0 / (_distance - _midDistance) * 1.0;
    }
    _x = percent * (endX - startX) + startX;    
    _y = percent * (endY - startY) + startY;
    
    return calcDirection(startX,startY,endX,endY);
  }

  // =======================================
  // Train Drawing
  // =======================================
  public void update() {
    move();
    drawTrain(_x, _y, _tl.getColor(), recalc());
  }
}