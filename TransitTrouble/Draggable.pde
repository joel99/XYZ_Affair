public interface Draggable {

  TrainLine getTrainLine();

  int getState();
  void setState(int newState);

  boolean isNear();

  void recalc();
  void update();
}