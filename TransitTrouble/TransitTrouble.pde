/*************************************
 * Transit Trouble by XYZ Affair 
 * <DESCRIPTION>
 *************************************/
//NOTE: SCREEN RATIO 3:2

ArrayList<Station> _stations = new ArrayList<Station>();
ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>();

//safer to have boolean locks than to check if station is null...
boolean lockedActive = false;
Station activeStation = null;
boolean lockedTarget = false;
Station targetStation = null;

Map map = new Map();

void setup() {
  smooth(4);
  strokeWeight(5);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change
  // ==================================================
  // Debugging
  for (int i = 0; i < 2; i++) {
    genStation();
  }
  Connector c = new Connector(_stations.get(0), _stations.get(1));
  _trainlines.add(new TrainLine(c));
  //for (Station s : _stations) {
   // _trainlines.get(0).addStation(s);
  //}
  // ==================================================
}

void draw() {
  background(255, 255, 255);
  map.debug(); //draws red dots
  ellipse(mouseX, mouseY, 60, 60);
  
  for (TrainLine tl : _trainlines) {
    tl.update();
  }
  updateDrag();
}

//might as well be obsolete rn.
void updateDrag(){
  //hmm..
  /*
  if (mousePressed) {
    int falloff = 30;
    //line creation
    //if no station has been selected.
    if (!lockedActive) {
      //check all stations to see if mouse might be referring to it
      for (Station s : _stations) {
        if (s.isEnd() && dist(s.getX(), s.getY(), mouseX, mouseY) < falloff) {
          activeStation = s;
          lockedActive = true;
          println("STATION SELECTED!");
          break;
        }
      }
    }
    //station is already being connected
    else {
      //no target in particular
      if (!lockedTarget) {
        line(activeStation.getX(), activeStation.getY(), mouseX, mouseY);
        //check to see if close to other stations
        for (Station s : _stations) {
          //don't connect to yourself
          if (s == activeStation) 
            continue;
          if (dist(s.getX(), s.getY(), mouseX, mouseY) < 2 * falloff) {
            lockedTarget = true;
            activeStation.getTrainLine().connect(activeStation, s);
            targetStation = s;
            break;
          }
        }
      }
      //station is locked on - increase falloff. continue checking for different connections.
      else {
        activeStation.getTrainLine().connect(activeStation, targetStation);
        //very far? unlock
        if (dist(targetStation.getX(), targetStation.getY(), mouseX, mouseY) > 4 * falloff){
          targetStation = null;
          lockedTarget = false;
        }
      }
    }
  }
  */
}


// ==================================================
// Helper Methods
// ==================================================
void keyPressed(){
  println("LMAO");
  genStation();
  println("LMNAO");
  _trainlines.get(0).addTerminal(_stations.get(_stations.size() - 1));
}

void mousePressed() {
  //get mouseX, mouseY.
}

void mouseReleased() {
  //if there's something to add.
  if (lockedTarget){
    //activeStation.getTrainLine().addStation(activeStation, targetStation);
  }
  activeStation = null;
  lockedActive = false;
  targetStation = null;
  lockedTarget = false;
}


void genStation() {
  ///1s for padding...
  int pad = 2;
  int newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
  int newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
  int ctr = 0;
  while (map.slots[newStationX][newStationY]) {
    if (ctr == 1000) {
      grow();
    }
    newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
    newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
    ctr++;
  }
  _stations.add(new Station(map.transform(newStationX, newStationY)));
  // print(_stations.get(_stations.size() - 1)._x + " " + _stations.get(_stations.size() - 1)._y + "\n");
  //voids station and everything immediately next to it as spots for future stations...
  for (int i = newStationX - 2; i < newStationX + 3; i++) {
    for (int j = newStationY - 2; j < newStationY + 3; j++) {
      map.slots[i][j] = true;
    }
  }

  if ((map.maxX - map.minX) * (map.maxY - map.minY) / _stations.size()  < 20) {
    grow();
  }
}

void grow() {
  map.grow();    
  for (Station s: _stations){
    s.recalc(map.transform(s.getGridX(), s.getGridY()));
  }
  for (TrainLine tl: _trainlines){
    tl.recalc();
  }
}