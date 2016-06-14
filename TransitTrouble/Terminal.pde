//class Terminal -- holds end grips data. extends in opposite direction of next connector line

public class Terminal implements Draggable {

  //holds first connector to get direction
  private Station _s;
  private TrainLine _tl;
  private boolean isNotInit;
  public int state;
  int x;
  int y;

  public Terminal(Station s, TrainLine tl) {
    _s = s;
    _tl = tl;
    isNotInit = true;
  }

  public Station getStation() {
    return _s;
  }

  void setStation(Station s) {
    _s = s;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public void setX(int newX) {
    x = newX;
  }

  public void setY(int newY) {
    y = newY;
  }

  public int getState() {
    return state;
  }

  public void setState(int newState) {
    state = newState;
  }

  public TrainLine getTrainLine() {
    return _tl;
  }

  public boolean isNear() {
    return dist(mouseX, mouseY, x, y) < width / (2 * map.activeW + 1) / 5;
  }

  //where do I go, sadbois...
  void calcXY() {
    //in case of two terminals, i'm deceased.
    int len = width / (map.maxX - map.minX) / 2;
    Draggable d = _tl.getOtherEnd(_s, this);
    if (d != null) {
      if (d instanceof Terminal) {
        Terminal t = (Terminal) d;
        x = _s.getX() - len;
        y = _s.getY();
        t.setX(_s.getX() + len);
        t.setY(_s.getY());
      } else {//it's a connector, which we want.
        Connector c = (Connector)d; 
        //get Xs and Ys, go opposite way for a bit. 
        int x1 = _s.getX();
        int y1 = _s.getY();
        int x2, y2;
        if (c.hasMid()) {
          x2 = c.getTransMid()[0];
          y2 = c.getTransMid()[1];
        } else {
          if (_s == c.getStart()) {
            x2 = c.getEnd().getX();
            y2 = c.getEnd().getY();
          } else {
            x2 = c.getStart().getX();
            y2 = c.getStart().getY();
          }
        }
        //xs and ys gotten, scale down
        int dx = x2 - x1;
        int dy = y2 - y1;
        if (dx != 0)
          dx = dx / int(abs(dx)) * len;
        if (dy != 0)
          dy = dy / int(abs(dy)) * len;
        x = x1 - dx;
        y = y1 - dy;
      }
    }
  }

  public void recalc() {
    calcXY();
  }  

  public void update() {
    if (state == -1)
      stroke(_tl.getColor() + 50);
    else 
    stroke(_tl.getColor());
    if (isNotInit) {
      calcXY();
      isNotInit = false;
    }
    line(x, y, _s.getX(), _s.getY());
  }
}