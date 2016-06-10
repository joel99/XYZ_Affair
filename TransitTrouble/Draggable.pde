public interface Draggable{

  TrainLine getTrainLine();
  
  //int getX();
  //int getY();
  boolean isNear();
  void recalc();
  void update();//who needs a drawable interface anyway
}