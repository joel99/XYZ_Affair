public interface Draggable{
  
  boolean isNear(int falloff); 
  TrainLine getTrainLine();
  
  int getX();
  int getY();
}