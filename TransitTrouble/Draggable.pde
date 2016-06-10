public interface Draggable{

  TrainLine getTrainLine();
  
  //int getX();
  //int getY();
  int getState();
  void setState(int newState);
  boolean isNear();
  void recalc();
  void update();//who needs a drawable interface anyway
}