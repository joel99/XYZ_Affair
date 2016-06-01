public class Map{
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
  
  public Map(){
    w = 60;
    h = 90;
    //center holds bottom right corner of array;
    centerX = w / 2; 
    centerY = h / 2; 
    slots = new boolean[w][h];
    activeW = 4;
    activeH = 6;
    maxX = centerX + activeW;
    maxY = centerY + activeH;
    minX = centerX - 1 - activeW;
    minY = centerY - 1 - activeH;
  }
  
  //transforms slotX and slotY to map coords.
  public int[] transform(int slotX, int slotY){
    int unitX = width / (2 * activeW + 1); //how many pixels per slot
    int unitY = height / (2 * activeH + 1);
    //top left corner of slots (centerX - 1 - activeW)(centerY - 1 - activeY) maps to 0,0 on world
    //bottom right corner is (centerX + activeW)(centerY + activeY) and amps to width/height
    //slots[centerX - 1 - activeW][centerY - 1 - activeY];
    int retX = unitX * (slotX - minX);
    int retY = unitY * (slotY - minY);
    return new int[]{retX, retY};
    }
    
    public void grow(){
      maxX += 1;
      maxY += 1;
      minX -= 1;
      minY -= 1;
    }
}