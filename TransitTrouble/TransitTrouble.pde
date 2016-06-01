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
  for (int i = 0; i < 5; i++) {
    genStation();
    //println("station made");
  }
  
  // ==================================================
}

void draw() {
  map.debug();
  for (Station s : _stations) {
    s.update();
  }
}

void genStation(){
  ///1s for padding...
  int pad = 2;
  int newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
  int newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
  while (map.slots[newStationX][newStationY]){
    newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
    newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
  }
  _stations.add(new Station(map.transform(newStationX, newStationY)));
  //voids station and everything immediately next to it as spots for future stations...
  for (int i = newStationX - 2; i < newStationX + 3; i++){
    for (int j = newStationY - 2; j < newStationY + 3; j++){
      map.slots[i][j] = true;
    }
  }
}