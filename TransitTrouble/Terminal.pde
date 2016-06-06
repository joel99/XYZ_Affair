//class Terminal -- holds end grips data. extends in opposite direction of next connector line

public class Terminal implements Draggable{

  private Station _s;
  //holds first connector to get direction
  private Connector _c;
  int x;
  int y;

  public Terminal(Station s, Connector c) {
    _s = s;
    _c = c;
    calcXY();
  }

  public Station getStation() {
    return _s;
  }

  void setStation(Station s) {
    _s = s;
  }
  
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
  
  void calcXY() {
    int len = width / (map.maxX - map.minX) / 2;
    //get Xs and Ys, go opposite way for a bit. 
    int x1 = _s.getX();
    int y1 = _s.getY();
    int x2, y2;
    if (_c.hasMid()) {
        x2 = _c.getTransMid()[0];
        y2 = _c.getTransMid()[1];
    }
    else {
      if (_s == _c.getStart()){
        x2 = _c.getEnd().getX();
        y2 = _c.getEnd().getY();
      }
      else{
        x2 = _c.getStart().getX();
        y2 = _c.getStart().getY();
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
    println("CALCULATED!" + x + y);
  }
  
  public boolean isNear(int falloff){
    return dist(mouseX, mouseY, x, y) < falloff;
  }
  
  void recalc(){
    calcXY();
  }  
  
  void update(){
    line(x, y, _s.getX(), _s.getY());  
  }
}