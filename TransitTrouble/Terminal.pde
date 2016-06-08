//class Terminal -- holds end grips data. extends in opposite direction of next connector line

public class Terminal implements Draggable{

  private Station _s;
  //holds first connector to get direction
  private TrainLine _tl;
  int x;
  int y;

  public Terminal(Station s, TrainLine tl) {
    _s = s;
    _tl = tl;
    calcXY();
  }

  public Station getStation() {
    return _s;
  }

  void setStation(Station s) {
    _s = s;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public TrainLine getTrainLine(){
    return _tl;
  }
  
  public boolean isNear(int falloff){
    return dist(mouseX, mouseY, x, y) < falloff;
  }
  
  
  void calcXY() {
    //Connector c = _s.getOtherEnd(this, _tl);
    int len = width / (map.maxX - map.minX) / 2;
    //get Xs and Ys, go opposite way for a bit. 
    int x1 = _s.getX();
    int y1 = _s.getY();
    int x2, y2;
    if (c.hasMid()) {
        x2 = c.getTransMid()[0];
        y2 = c.getTransMid()[1];
    }
    else {
      if (_s == c.getStart()){
        x2 = c.getEnd().getX();
        y2 = c.getEnd().getY();
      }
      else{
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
    println("CALCULATED!" + x + y);
  }
  
  void recalc(){
    calcXY();
  }  
  
  void update(){
    line(x, y, _s.getX(), _s.getY());  
  }
}