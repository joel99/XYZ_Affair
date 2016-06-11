public class Clock{
  
  private int _x;
  private int _y;
  private int _time; //0 - 360
  private int _r;
  private int _day;
  private final String[] DAYS = {"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};
  
  public Clock(int x, int y){
    _x = x;
    _y = y;
    _r = 20;
    _time = 0;
    _day = 0;
  }
  
  void update() {
  
    fill(80);
    noStroke();
    _time += 2;
    if (_time >= 360) {
      _day = (_day + 1) % 7;
      _time -= 360;
    }
    ellipse(_x, _y, _r, _r);
    stroke(255);
    strokeWeight(4);
    line(_x, _y, cos(radians(_time)) * _r + _x, sin(radians(_time)) * _r + _y);
    stroke(0);
    text(DAYS[_day], _x - 3 * _r, _y - 2 * _r);
  
  }
}