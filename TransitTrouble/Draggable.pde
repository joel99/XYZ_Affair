public interface Draggable{
  
  boolean isNear(int falloff); 
  TrainLine getTrainLine();
  
  //int getX();
  //int getY();
  void recalc();
  void update();//who needs a drawable interface anyway
}