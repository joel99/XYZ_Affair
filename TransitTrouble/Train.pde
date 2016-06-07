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
  
  
  public Train( Connector kinektor ) {
    _carriage = new Stack<Person>(); // Initial Holding Capacity
    _connector = kinektor;
    _x = _connector.start.getX();
    _y = _connector.start.getY();
    
    boolean _reachedTarget = false;
    
    if ( _connector.hasMid() ) {
      _targetX = _connector.transMid[0]; //get to mid first
      _targetY = _connector.transMid[1];
      _reachedMid = false;
    }
    else _reachedMid = true; //target will be redirected to station in move()
  }
   
  public void move() {    
    int threshold = 5; //5 pixel variability
    if ( sqrt( pow(_targetX - _x, 2) + pow(_targetY - _y, 2) ) < threshold) { //target is either mid or end
      if ( _reachedMid ) { //if had already reached mid, then target was end station's target and you've reached the end
        //todo: SET TARGET TO NEW STATION
      }
      
      
    }
    else {
      _x -= Integer.compare(_x, _targetX); //if x<targetX: move -1, if same: stay in place, if x>targetX: move +1
      _y -= Integer.compare(_y, _targetY);
    }
    
  }
  
  public void update() {
    move();
    println( "ME: " + _x + " " + _y );
    println( "TAR: " + _targetX + " " + _targetY );
    rect(_x, _y, 30, 15);
  }
  
}