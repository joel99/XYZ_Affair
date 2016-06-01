public class Map {
  //false - unoccupied, true - occupied
  public boolean[][] slots;

  int w;
  int h;
  int activeW; //how many slots it extends past centerX
  int activeH;
  int centerX;
  int centerY;

  //slot constants;
  public int maxX;
  public int maxY;
  public int minX;
  public int minY;

  public Map() {
    //stroke(255, 0, 0);
    w = 90;
    h = 60;
    //center holds bottom right corner of array;
    centerX = w / 2; 
    centerY = h / 2; 
    slots = new boolean[w][h];
    activeW = 6;
    activeH = 4;
    maxX = centerX + activeW;
    maxY = centerY + activeH;
    minX = centerX - 1 - activeW;
    minY = centerY - 1 - activeH;
  }

  //transforms slotX and slotY to map coords.
  public int[] transform(int slotX, int slotY) {
    int unitX = width / (2 * activeW + 1); //how many pixels per slot
    int unitY = height / (2 * activeH + 1);
    //top left corner of slots (centerX - 1 - activeW)(centerY - 1 - activeY) maps to 0,0 on world
    //bottom right corner is (centerX + activeW)(centerY + activeY) and amps to width/height
    //slots[centerX - 1 - activeW][centerY - 1 - activeY];
    int retX = unitX * (slotX - minX);
    int retY = unitY * (slotY - minY);
    //flip retX, retY because processing is dumb.
    return new int[]{retX, retY, slotX, slotY};
  }

  public void grow() {
    maxX += 1;
    maxY += 1;
    minX -= 1;
    minY -= 1;
    activeW++;
    activeH++;
  }

  public void debug() {
    stroke(255, 0, 0);
    for (int i = minX; i <= maxX; i++) {
      for (int j = minY; j <= maxY; j++) {
        ellipse(transform(i, j)[0], transform(i, j)[1], 2, 2);
      }
    }
  }
}