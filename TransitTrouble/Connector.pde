/*************************************
 * Connector Class 
 * Links two Stations together.
 *************************************/

public class Connector implements Draggable {
  // =======================================
  // Instance Variables
  // =======================================
  int state; //construction level
  // 0 - tentative
  // 1 - confirmed
  //-1 - confirmed to be possibly deleted // DELETE LATER
  Station _start, _end;
  TrainLine _tl;
  int[] mid;  // Grid coordinates of turning point
  int[] transMid;  // Map coordinates of turning point (post transformation) 

  // =======================================
  // Default Constructor
  // =======================================
  public Connector(Station s1, Station s2, TrainLine tl) {
    _start = s1;
    _end = s2;
    _tl = tl;
    calcMid(_start, _end);
    //load up middle point, if existing.
    recalc();
    state = 0;
  }

  // =======================================
  // Mutators and Accessors
  // ======================================= 
  /** hasMid() 
   * returns if a turning point exists for this Connector */
  boolean hasMid() {
    return mid != null;
  }

  /** getTransMid()
   * returns coordinates of transformed point, [x, y] */
  int[] getTransMid() {
    return transMid;
  }
  /** getMid()
   * returns grid coorinates of turning point, [x, y] */
  int[] getMid  () {
    return mid;
  }

  /** getStart(), getEnd()
   * returns the stations at the start and end of this Connector */
  Station getStart() {
    return _start;
  }
  Station getEnd() {
    return _end;
  }

  /** getTrainLine()
   * returns the TrainLine this connector belongs to */
  public TrainLine getTrainLine() {
    return _tl;
  }

  // OBSELETE
  public int getState() {
    return state;
  }
  public void setState(int newState) {
    state = newState;
  } 

  // =======================================
  // Connector Methods
  // =======================================
  /** isOn - checks if triangle inequality is satisfied
   * @param x1 - Map X of Station 1
   * @param y1 - Map Y of Station 1
   * @param x2 - Map X of Station 2
   * @param y2 - Map Y of Station 2
   * @param x3 - Mouse X coordinate
   * @param y3 - Mouse Y coordinate
   * @param threshold - Threshold value in pixels
   * returns whether the  */
  public boolean isOn(int x1, int y1, int x2, int y2) {
    float dist = dist(x1, y1, x2, y2); // Distance between S1 and S2
    float dist1 = dist(x1, y1, mouseX, mouseY); // Distance between S1 and Mouse
    float dist2 = dist(mouseX, mouseY, x2, y2); // Distance between S2 and Mouse
    return dist1 + dist2 < dist + 5; // Threshold Value
  } 
  public boolean isOn(int x1, int y1, int x2, int y2, int x3, int y3, int threshold) {
    float dist = dist(x1, y1, x2, y2);
    float dist1 = dist(x1, y1, x3, y3);
    float dist2 = dist(x3, y3, x2, y2);
    return dist1 + dist2 < dist + threshold;
  }

  /** isNear - checks if triangle inequality is satisfied for Connectors
   * Helper function to account for cases when the connector has a turning point */
  public boolean isNear() {
    if (hasMid()) {
      return isOn(_start.getX(), _start.getY(), transMid[0], transMid[1]) || isOn(transMid[0], transMid[1], _end.getX(), _end.getY());
    } else {
      return isOn(_start.getX(), _start.getY(), _end.getX(), _end.getY());
    }
  }

  /** calcMid - Calculates grid coordinates of turning point, if they exist
   * precond: 
   * postcond: mid is updated to reflect turning point; null if no turning point exists
   * adapted from connect() in Station */
  void calcMid(Station s1, Station s2) {
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
      return;
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
      mid = new int[]{diagx, diagy};
    }
  }

  /** recalc()
   * updates Map coordinates */
  public void recalc() {
    if (hasMid()) {
      transMid = map.transform(mid[0], mid[1]);
    }
  }

  /** otherEnd(Station) - finds Station at other end of this connector
   * precond: Station s is one of _start or _end
   * postcond: If s == _start, _end
   *              s == _end, _start
   *              else, null */
  public Station otherEnd(Station s) {
    if (s == _start)
      return _end;
    if (s == _end)
      return _start;
    return null; 
  }

  // =======================================
  // Drawing Connector
  // =======================================
  public void update() {
    if (state == -1)
      stroke(_tl.getColor() + 50);
    else 
    stroke(_tl.getColor());
    if (!hasMid()) {
      line(_start.getX(), _start.getY(), _end.getX(), _end.getY());
    } else {
      line(_start.getX(), _start.getY(), transMid[0], transMid[1]);
      line(transMid[0], transMid[1], _end.getX(), _end.getY());
    }
  }
}