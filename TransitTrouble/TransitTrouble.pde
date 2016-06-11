/*************************************
 * Transit Trouble by XYZ Affair 
 * <DESCRIPTION>
 *************************************/
//NOTE: SCREEN RATIO 3:2
import java.util.LinkedList;

ArrayList<Station> _stations = new ArrayList<Station>();
ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>();

//safer to have boolean locks than to check if station is null...
boolean lockedActive = false;
ArrayList<Draggable> activeDrags = null;
ArrayList<Station> activeStations = null;
TrainLine activeTrainLine;
//LinkedList dragList = null;
boolean lockedTarget = false;
Station targetStation = null;

Train testTrain;

Map map = new Map();

void setup() {
  smooth(4);
  strokeWeight(8);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change
  
  activeDrags = new ArrayList<Draggable>();
  activeStations = new ArrayList<Station>();
  activeTrainLine = null;
  // ==================================================
  // Debugging
  for (int i = 0; i < 1; i++) {
    genStation();
    //genStation();
  }
  _trainlines.add(new TrainLine(_stations.get(0)));
  genStation();
  _trainlines.get(0).addTerminal(_stations.get(0), _stations.get(1));
  
  /*
  _trainlines.get(0).connect( _stations.get(0), _stations.get(1) );
  _trainlines.get(0).addTerminal( _stations.get(0), _stations.get(1) );
  _trainlines.get(0).update();
  */
  //Connector c = new Connector(_stations.get(0), _stations.get(1));
  

  testTrain = new Train((Connector)_trainlines.get(0)._stationEnds.get(1).getA());
  
  /*
  for (Station s : _stations) {
   _trainlines.get(0).addStation(s);
  } 
  */
  // ==================================================
}

void draw() {
  background(255, 255, 255);
  
  map.debug(); //Debugging - Maps red dots to each grid coordinate
  //stroke(255);
  fill(255);
  ellipse(mouseX, mouseY, 60, 60); // Debugging

  for (TrainLine tl : _trainlines) {
    tl.update();
  }
  for (Station s : _stations) {
    s.update();
    textSize(16);
    fill(0);
    text(_stations.indexOf(s), s.getX(), s.getY());
  }

  testTrain.update(); //temporary

  updateDrag();
}

//might as well be obsolete rn.
void updateDrag() {
  if (mousePressed) {
    //check for things to drag - terminal, station, connector
    //if nothing has been locked from yet
    if (!lockedActive) {
      search:
      for (TrainLine tl : _trainlines) {
        //evaluate stations first to avoid crashing
        for (Terminal t : tl.getTerminals()) {
          if (t.isNear()) {
            activeDrags.add(t);
            lockedActive = true;
            activeTrainLine = tl;
            //turns immediate station/connector/terminal to tentative.
            break search;
          }
        }
        for (Pair p : tl.getStationEnds()){
          if (p.getB().isNear()){
            activeDrags.add(p.getB());
            lockedActive = true;
            activeTrainLine = tl;
            break search;
          }
          else if (p.getA().isNear()){
            activeDrags.add(p.getA());
            lockedActive = true;
            activeTrainLine = tl;
            break search;
          }
        }
        //other draggable things here.
      }
    }
    
    else {
      //todo: replace with queue
      //get ready to QUEUE UP OH YEAH
      //track which stationss mouse goes through
      //if not active, add to list, set state based on if in train line or not.
      //activeDrags.add();
      //activeStations.add();
      //DRAW DRAW DRAW
      for (Draggable d: activeDrags){
        d.update();
      }
      for (Station s: activeStations){
        s.update();
      }
      //
      for (Station s: _stations) {
        //to do - add cooldown timer.
        if (s.isNear()){
          //if station is not active, add to queue of interest
          if (activeStations.indexOf(s) == -1){
            activeStations.add(s);
            //if station is not on the train line, add the station of concern.
            if (activeTrainLine.indexOf(s) == -1){
              if (activeDrags.indexOf(s) == -1)
                activeDrags.add(new Connector(activeStations.get(activeStations.size() - 1), s, activeTrainLine));
              else if (activeDrags.indexOf(s) == activeDrags.size() - 1)
                activeDrags.remove(activeDrags.size() - 1);
              //else
               // continue;
              //s.setState(1);
            }
            
            else {
              Pair temp = activeTrainLine.getStationEnds().get(activeTrainLine.indexOf(s)); // is a pair
              temp.getA().setState(-1);
              temp.getB().setState(-1);
              //remove from train line
            }
          }
          else {//already queued up - remove from queue only if at top, otherwise ignore.
            
          }
        }
      }
      
    }
    
  }

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
        if (dist(targetStation.getX(), targetStation.getY(), mouseX, mouseY) > 4 * falloff) {
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
void keyPressed() {
  println("LMAO");
  genStation();
  _trainlines.get(0).addTerminal(_trainlines.get(0).getStation(0), _stations.get(_stations.size() - 1));
}

void mousePressed() {
  //get mouseX, mouseY.
}

void mouseReleased() {
  //if there's something to add.
  for (Draggable d: activeDrags){
    if (d.getState() == 0)
      d.setState(1);
    else if (d.getState() == -1){
    
    }
  }
  activeDrags = new ArrayList();
  activeStations = new ArrayList();
  //activeConnector = null;
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
  for (Station s : _stations) {
    s.recalc();
  }
  for (TrainLine tl : _trainlines) {
    tl.recalc();
  }
}