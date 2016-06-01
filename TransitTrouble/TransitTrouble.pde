/*************************************
 * Transit Trouble by XYZ Affair 
 * <DESCRIPTION>
 *************************************/
//NOTE: SCREEN RATIO 3:2
ArrayList<Station> _stations = new ArrayList<Station>();
Map map = new Map();

void setup() {
  smooth(4);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change
  // ==================================================
  // Debugging
  for (int i = 0; i < 3; i++) {
    //added 1s for padding.
    int newStationX = 1 + map.minX + int(random(map.maxX - map.minX - 1));
    int newStationY = 1 + map.minY + int(random(map.maxY - map.minY - 1));
    while (map.slots[newStationX][newStationY]){
      newStationX = 1 + map.minX + int(random(map.maxX - map.minX - 1));
      newStationY = 1 + map.minY + int(random(map.maxY - map.minY - 1));
    }
    //now station is unoccupied.
    _stations.add(new Station(map.transform(newStationX, newStationY)));
    
    //println("station made");
  }
  // ==================================================
}

void draw() {
  for (Station s : _stations) {
    s.update();
  }
}