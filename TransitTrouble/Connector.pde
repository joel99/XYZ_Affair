//class Connector - holds train line data between stations
//to implement draggable
public class Connector implements Draggable {
  //holds at most 3 nodes
  int pos; //in case more than train line passes through same spot
  int state; //construction level
  //0 - tentative
  //1 - confirmed
  //-1 - confirmed to be possibly deleted
  Station _start;
  Station _end;
  TrainLine _tl;
  int[] mid;  //holds turning point (if existing)
  int[] transMid;  //holds actual x y coords of mid.
  //make HITBOXES!!!

  public Connector(Station s1, Station s2, TrainLine tl) {
    _start = s1;
    _end = s2;
    _tl = tl;
    calcMid(_start, _end);
    //load up middle point, if existing.
    recalc();
    state = 0;
  }

  boolean hasMid() {
    return mid != null;
  }

  int[] getTransMid() {
    return transMid;
  }

  Station getStart() {
    return _start;
  }
  Station getEnd() {
    return _end;
  }

  public TrainLine getTrainLine() {
    return _tl;
  }

  public int getState(){
    return state;
  }
  
  public void setState(int newState){
    state = newState;
  }
  
  public boolean isOn(int x1, int y1, int x2, int y2, int x3, int y3, int threshold){
    float dist = dist(x1, y1, x2, y2);
    float dist1 = dist(x1, y1, x3, y3);
    float dist2 = dist(x3, y3, x2, y2);
    return dist1 + dist2 < dist + threshold;
  }
  
  public boolean isOn(int x1, int y1, int x2, int y2) {
    return isOn(x1, y1, x2, y2, mouseX, mouseY, width / (2 * map.activeW + 1) / 4);
  }
  
  public boolean isNear() {
    if (hasMid()) {
      return isOn(_start.getX(), _start.getY(), transMid[0], transMid[1]) || isOn(transMid[0], transMid[1], _end.getX(), _end.getY());
    } else {
      return isOn(_start.getX(), _start.getY(), _end.getX(), _end.getY());
    }
  }

  //adapted from connect()
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

  public void recalc() {
    if (hasMid()) {
      transMid = map.transform(mid[0], mid[1]);
    }
  }

  public void update() {
    if (state == -1)
      stroke(_tl.getColor() + 50);
    else 
      stroke(_tl.getColor());
    if (!hasMid()) {
      //println("I don't have a mid");
      line(_start.getX(), _start.getY(), _end.getX(), _end.getY());
    } else {
      line(_start.getX(), _start.getY(), transMid[0], transMid[1]);
      line(transMid[0], transMid[1], _end.getX(), _end.getY());
    }
  }
}