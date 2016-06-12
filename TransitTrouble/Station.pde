/*************************************
 * Station Class
 * Contains a queue for Persons to enter a Train
 *************************************/

import java.util.PriorityQueue;

public class Station {
  // =======================================
  // Instance Variables
  // =======================================
  private int _shape; // (0 to 6);
  private int _x;
  private int _y;
  private int _gridX;
  private int _gridY;
  private float _crowd; // Health - Higher = Bad
  private PriorityQueue<Person> _line;
  private ArrayList<TrainLine> _trainLines;
  private boolean isEnd;
  private int _timeStart, _timeEnd; // Timing - Used for passenger generation
  private static final int _CAPACITY = 12; // 12 people at most
  private Draggable d1;
  private Draggable d2;

  // =======================================
  // Default Constructor
  // Creates a station on the lattice grid of Map.
  // =======================================
  public Station(int[] coords) {
    _shape = 0; // To adjust depending on time
    _x = coords[0];
    _y = coords[1];
    _gridX = coords[2];
    _gridY = coords[3];
    _line = new PriorityQueue<Person>();
    _timeStart = millis();
    _timeEnd = _timeStart + 15000;
    _trainLines = new ArrayList<TrainLine>();
    // println(_shape, _x, _y, _gridX, _gridY); // Debugging
  }

  // =======================================
  // Person Generation and Calculations
  // =======================================
  /** addPassenger - adds a passenger to the line
   * precond: _timeEnd >= _timeStart, Station capacity is not at max
   * postcond: _line has another Person, _timeStart and _timeEnd are updated accordingly */
  boolean addPassenger() {
    if (_line.size() >= _CAPACITY) // Station Capacity = 12
      return false; // Passenger not added
    int tmpPriority = 0;
    float roll = random(1);
    if (0.25 > roll) // 20%
      tmpPriority++; // 1
    if (0.05 > roll) // 5%
      tmpPriority++; // 2

    _timeEnd = millis();
    _timeStart = _timeEnd + 1000 * int(random(5)); // Adjust Later - Add 0 to 4 seconds of extra delay

    // print("Passenger added!"); // Debugging

    return _line.add(new Person(tmpPriority));
  }

  /** calculateCrowd - calculates crowdedness of Station
   * precond:
   * postcond: _crowd is updated accordingly */
  void calculateCrowd() {
    _crowd += (_line.size() - 6) * 0.001; // BALANCE LATER
    if (_crowd < 0)
      _crowd = 0;
    if (_crowd > 999) // END GAME - IMPLEMENT LATER
      ;
  }

  // =======================================
  // Mutators and Accessors
  // ======================================= 
  /** getX 
   * returns x location of station **/
  int getX() {
    return _x;
  }
  /** getGridX 
   * returns x location of station on grid **/
  int getGridX() {
    return _gridX;
  }

  /** getY
   * returns y location of station **/
  int getY() {
    return _y;
  }
  /** getGridY 
   * returns y location of station on grid **/
  int getGridY() {
    return _gridY;
  }

  /** setX
   * sets x location of station on map **/
  int setX(int newX) {
    int oldX = _x;
    _x = newX;
    return oldX;
  }
  /** setY
   * sets y location of station on map **/
  int setY(int newY) {
    int oldY = _y;
    _y = newY;
    return oldY;
  }

  public boolean isNear() {
    return dist(mouseX, mouseY, _x, _y) < width / (2 * map.activeW + 1) / 2;
  }

  // =======================================
  // Methods
  // ======================================= 
  //PRECOND: assuming no train line is set.
  /** setTrainLine
   * sets trainline(s) that this Station belongs to */
  void addTrainLine(TrainLine tl) {
    _trainLines.add(tl);
  }
  /** getTrainLine
   * returns trainline(s) that this Station belongs to */
  ArrayList<TrainLine> getTrainLines() {
    return _trainLines;
  }

  void removeTrainLine(TrainLine tl) {
    _trainLines.remove(tl);
  }

  //returns two connectors given trainline
  Draggable[] getEnds(TrainLine tl) {
    return null;
  }

  //returns other end of station on same train line given one end.
  Draggable getOtherEnd(Draggable d, TrainLine tl) {
    //cases - d is terminal.
    tl.getOtherEnd(this, d);
    return null;
  }

  /** isEnd
   * returns whether this Station is at the front or end of the TrainLine */
  boolean isEnd() {
    return isEnd;
  }
  /** setEnd
   * precond: boolean b, telling whether this station is an end Station
   * postcond: isEnd is updated to reflect the Station's state */
  void setEnd(boolean b) {
    isEnd = b;
  }

  /** getCrowd
   * returns crowdedness value of this Station */
  float getCrowd() {
    return _crowd;
  }
  /** setCrowd
   * sets crowdedness value to specified float */
  void setCrowd(float newCrowd) {
    _crowd = newCrowd;
  }

  /** recalc
   * precond: integer array contained mapX and mapY
   * postcond: sets _x and _y accordingly */
  void recalc(){
    int[] temp = map.transform(_gridX, _gridY);
    _x = temp[0];
    _y = temp[1];
  } 

  // =======================================
  // Drawing Station
  // =======================================
  void update() {
    // Update Time
    _timeEnd = millis();

    // Update Crowdedness
    calculateCrowd();

    // Update Line
    if (_timeEnd - 1000 >= _timeStart) { // 1 seconds
      addPassenger();
    }
    // print(getCrowd()); // Debugging
    // println(_timeEnd, _timeStart);
    drawStationHealth(_x, _y, _crowd);
    drawStation(_x, _y, _shape);
    drawStationLine(_x, _y, _line);
  }
}