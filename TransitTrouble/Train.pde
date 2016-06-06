/*************************************
 * Train Class
 * Object that travels on a TrainLine to various Stations, holds Persons
 *************************************/

import java.util.Stack;

public class Train {
  Stack<Person> _carriage;
  TrainLine _line;
  Station _target;
  int _x, _y, _targetX, _targetY;
  int curInd = 0; //TEMP
  
  public Train( TrainLine line, Station _start  ) { // Given a starting station and assigned train line
    _carriage = new Stack<Person>(); // Initial Holding Capacity
    _line = line;
    _target = _line._stations.get(0);
    _x = _start.getX();   //TO DO: change to grid coords?
    _y = _start.getY();
    _targetX = _target.getX();
    _targetY = _target.getY();
  }
   
  public void move() {
    int threshold = 5; //5 pixel variability
    if ( sqrt( pow(_targetX - _x, 2) + pow(_targetY - _y, 2) ) < threshold) {
      //you made it to target, so set your target to a new station
      _target = _line._stations.get( curInd );
    }
    else {
      _x += Integer.compare(_x, _targetX); //if x<targetX: move -1, if same: stay in place, if x>targetX: move +1
      _y += Integer.compare(_y, _targetY);
    }
  }
  
  public void update() {
    move();
    rect(_x, _y, 30, 15);
  }
  
}