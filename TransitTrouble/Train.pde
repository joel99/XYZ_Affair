/*************************************
 * Train Class
 * Object that travels on a TrainLine to various Stations, holds Persons
 *************************************/

import java.util.Stack;

public class Train {
  ArrayList<Person> _carriage;
  TrainLine _tl;
  Connector _connector;
  int _capacity = 6;
  int _x, _y, _targetX, _targetY;
  int _offsetX = 15;
  int _offsetY = 10;
  boolean _reachedMid;
  boolean _docked;
  boolean _lock = false; //used for when train triggers _reachedMid multiple times
  //public static final int peakVelocity = 3;
  
  int dir;
  
  public Train( int x, int y, Connector kinektor ) {
    _carriage = new ArrayList<Person>(); // Initial Holding Capacity
    _connector = kinektor;
    _tl = _connector.getTrainLine();
    _docked = false;
    //snap to connector line.
    //SNAP to whichever part it's closer to.
    int x1 = _connector._start.getX();
    int y1 = _connector._start.getY();
    int x2 = _connector._end.getX();
    int y2 = _connector._end.getY();
    if (_connector.hasMid()){
    int xmid = _connector.getTransMid()[0];
    int ymid = _connector.getTransMid()[1];
    }
    else{
    }
    _x = _connector._start.getX();
    _y = _connector._start.getY();
    
    dir = 1;
    
    //boolean _reachedTarget = false;

    boolean _reachedTarget = false;
    _docked = false;

    if ( _connector.hasMid() ) {
      
      _targetX = _connector.transMid[0]; //get to mid first
      _targetY = _connector.transMid[1];
      _reachedMid = false;
    } else {
      _reachedMid = true; //target will be redirected to station in move()
      _targetX = _connector._end.getX();
      _targetY = _connector._end.getY();
      _x = x;
      //_y = (dy / dx) * (_x - x1) + y1;
    }
  }

  public void move() {    
    int threshold = 5; //5 pixel variability
    if ( sqrt( pow(_targetX - _x, 2) + pow(_targetY - _y, 2) ) < threshold ) { //target is either mid or end
      if ( _reachedMid && !_lock ) { //if had already reached mid, then target was end station's target and you've reached the end
        _docked = true;
        _targetX = _connector._end.getX();
        _targetY = _connector._end.getY();
      } else { //just reached mid
        _reachedMid = true;
        _lock = true;
        _targetX = _connector._end.getX();
        _targetY = _connector._end.getY();
      }
    } else {
      _lock = false;
      _docked = false;
      _x -= Integer.compare(_x, _targetX); //if x<targetX: move -1, if same: stay in place, if x>targetX: move +1
      _y -= Integer.compare(_y, _targetY);
    }
  }
  
  public void update() {
    move();
    fill(_connector.getTrainLine().c);


    
    int deltax = _targetX - _x;
    int deltay = _targetY - _y;
    if (deltax != 0 && deltay != 0){//we're on a diagonal.
      int mult = (deltax * deltay) / abs(deltax * deltay);
      translate(_x-_offsetX, _y-_offsetY);
      rotate(mult * PI/4);
      rect(0, 0, 30, 20, 2);
      rotate(mult * -1 * PI / 4);
      translate(-_x+_offsetX, -_y+_offsetY);
    }
    
    else
      rect(_x-_offsetX, _y-_offsetY, 30, 20, 2);
    
  }
  
  public boolean isFull() {
    return _carriage.size() > _capacity; 
  }
  
  
  public void recalc() {
    //IMPLEMENTATION HERE???
  }
}