/*************************************
 * Train Class
 * Object that travels on a TrainLine to various Stations, holds Persons
 *************************************/

import java.util.Stack;

public class Train {
  Stack<Person> _carriage;
  Connector _connector;
  int _x, _y, _targetX, _targetY;
  boolean _reachedMid;
  boolean _docked;
  boolean _lock = false; //used for when train triggers _reachedMid multiple times
  //public static final int peakVelocity = 3;
  
  public Train( Connector kinektor ) {
    _carriage = new Stack<Person>(); // Initial Holding Capacity
    _connector = kinektor;
    _x = _connector._start.getX();
    _y = _connector._start.getY();
    
    boolean _reachedTarget = false;
    _docked = false;
    
    if ( _connector.hasMid() ) {
      _targetX = _connector.transMid[0]; //get to mid first
      _targetY = _connector.transMid[1];
      _reachedMid = false;
    }
    else {
      _reachedMid = true; //target will be redirected to station in move()
      _targetX = _connector._end.getX();
      _targetY = _connector._end.getY();
    }
  }
  
  public void move() {    
    int threshold = 5; //5 pixel variability
    if ( sqrt( pow(_targetX - _x, 2) + pow(_targetY - _y, 2) ) < threshold ) { //target is either mid or end
      if ( _reachedMid && !_lock ) { //if had already reached mid, then target was end station's target and you've reached the end
        _docked = true;
        _targetX = _connector._end.getX();
        _targetY = _connector._end.getY();
      }
      else { //just reached mid
        _reachedMid = true;
        _lock = true;
        _targetX = _connector._end.getX();
        _targetY = _connector._end.getY();
      }  
    }
    else {
      _lock = false;
      _docked = false;
      _x -= Integer.compare(_x, _targetX); //if x<targetX: move -1, if same: stay in place, if x>targetX: move +1
      _y -= Integer.compare(_y, _targetY);
    }
  }
 
  public void update() {
    move();
    fill(_connector.getTrainLine().c);
    rect(_x-15, _y-10, 30, 20, 2);
  }
  
}