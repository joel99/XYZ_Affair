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
  for (int i = 0; i < 1; i++) {
    genStation();
    //println("station made");
  }
  
  // ==================================================
  for (int i = map.minX; i < map.maxX; i++){
    for (int j = map.minY; j < map.maxY; j++){
      if (map.slots[i][j]) print("t ");
      else print("f ");
    }
  println();
  }
}

void draw() {
  map.debug();
  for (Station s : _stations) {
    s.update();
  }
}

void genStation(){
  ///1s for padding...
  int pad = 4;
  int newStationX = pad + map.minX + int(random(map.maxX - map.minX - pad));
  println();
  int newStationY = pad + map.minY + int(random(map.maxY - map.minY - pad));
  while (map.slots[newStationX][newStationY]){
    newStationX = pad + map.minX + int(random(map.maxX - map.minX - pad));
    newStationY = pad + map.minY + int(random(map.maxY - map.minY - pad));
  }
  System.out.println("New things selected... " + newStationX + " " + newStationY);
  _stations.add(new Station(map.transform(newStationX, newStationY)));
  //voids station and everything immediately next to it as spots for future stations...
  for (int i = newStationX - 2; i < newStationX + 3; i++){
    for (int j = newStationY - 2; j < newStationY + 3; j++){
      map.slots[i][j] = true;
    }
  }
}