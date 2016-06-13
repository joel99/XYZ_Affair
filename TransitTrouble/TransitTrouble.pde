/*************************************
 * Transit Trouble by XYZ Affair 
 *************************************/
//NOTE: SCREEN RATIO 3:2

// =======================================
// Instance Variables
// =======================================
import java.util.ArrayDeque;
import java.util.HashSet;

ArrayList<Train> _trains = new ArrayList<Train>();
ArrayList<Station> _stations = new ArrayList<Station>(); // List of active Stations
ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>(); // List of active Trainlines
ArrayList<Button> _buttons = new ArrayList<Button>(); //List of TRAINLINE BUTTONS
ButtonMovable trainButton;
ArrayDeque<Draggable> _selected = new ArrayDeque<Draggable>();
HashSet<Draggable> _hashed = new HashSet<Draggable>();
ArrayDeque<Station> _selectedStations = new ArrayDeque<Station>();
HashSet<Station> _hashedStations = new HashSet<Station>();
boolean _mousePressed = false; // Whether mouse has been pressed. 
boolean _mouseReleased = false;
boolean _lock; // Used if initial click didn't find anything.
TrainLine activeTrainLine = null;
int dragType = 0;
boolean justDraggedOnto = false; //aid for locking
//0 - nothing, 1 - terminal, 2 - connector
boolean _paused;

TrainLine activeLine;


// Game Map - GUI
Map map = new Map();
Clock gameClock;

// =======================================
// Setup
// =======================================
void setup() {
  smooth(4);
  strokeWeight(8);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change

  gameClock = new Clock(850, 50);

  // ==================================================
  // Debugging

  genStation();

  _trainlines.add(new TrainLine(_stations.get(0)));

  activeLine = _trainlines.get(0); //TEMPORARY

  genStation();
  _trainlines.get(0).addTerminal(_stations.get(0), _stations.get(1));

  buttonSetup();

  _trains.add(new Train(_stations.get(0), 
    _stations.get(1), 
    _trainlines.get(0)));

  /*
  _trainlines.get(0).connect( _stations.get(0), _stations.get(1) );
   _trainlines.get(0).addTerminal( _stations.get(0), _stations.get(1) );
   _trainlines.get(0).update();
   */
  //Connector c = new Connector(_stations.get(0), _stations.get(1));


  /*
  for (Station s : _stations) {
   _trainlines.get(0).addStation(s);
   } 
   */
  // ==================================================

  //_trains.add( new Train((Connector)_trainlines.get(0)._stationEnds.get(1).getA()) );
}

// =======================================
// Draw
// =======================================
void draw() {
  background(255, 255, 255);

  /*
   ArrayList<Train> _trains = new ArrayList<Train>();
   ArrayList<Station> _stations = new ArrayList<Station>(); // List of active Stations
   ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>(); // List of active Trainlines
   ArrayList<Button> _buttons = new ArrayList<Button>(); //List of ingame buttons
   */

  // println(_buttons);
  //println("STATIONS: " + _stations);
  //for (TrainLine tl : _trainlines) {
  //println("TRAINLINE: " + tl.getStations());
  //println("TRAINLINE PAIRS: " + tl.getStationEnds());
  //}

  map.debug(); //Debugging - Maps red dots to each grid coordinate
  //stroke(255);
  fill(255);

  //ellipse(mouseX, mouseY, 40, 40);      <-- Hollow circle cursor

  //  buttonSetup(); //when more train lines get added

  int initDay = gameClock.getDay();
  gameClock.update();
  int postDay = gameClock.getDay();
  if (initDay != postDay) { //if the day just changed in gameClock
    genStation();
  }


  if (!_paused) { // Unpaused
    background(255, 255, 255);
    map.debug(); //Debugging - Maps red dots to each grid coordinate
    fill(255);
    //ellipse(mouseX, mouseY, 40, 40);      <-- Hollow circle cursor // Debugging

    //  buttonSetup(); //when more train lines get added

    // Updating Clock
    updateClock();

    // Updating Trainlines 
    updateTrainLines();

    // Updating Stations
    updateStations();

    // Updating Buttons
    updateButtons();

    // Updating Trains
    updateTrains();
    
  } else { // Paused
    background(255, 255, 255);
    map.debug(); //Debugging - Maps red dots to each grid coordinate
    fill(255);
    
    updateClock(0);
    updateTrainLines(0); // No need for flag.
    updateStations(0);
    updateButtons(); // No need for flag.
    updateTrains(0);
  }
  updateDrag(); // Dragging Mechanism
}

// =======================================
// Updating
// =======================================
void updateTrainLines() {
  for (TrainLine tl : _trainlines) {
    tl.update();
  }
}
void updateTrainLines(int flag) {
  for (TrainLine tl : _trainlines) {
    tl.update(0);
  }
}

void updateStations() { 
  for (Station s : _stations) {
    s.update();
    textSize(16); // Debugging
    fill(0); // Debugging
    text(_stations.indexOf(s), s.getX(), s.getY()); // Debugging
  }
}
void updateStations(int flag) { 
  for (Station s : _stations) {
    s.update(0);
    textSize(16); // Debugging
    fill(0); // Debugging
    text(_stations.indexOf(s), s.getX(), s.getY()); // Debugging
  }
}

void updateButtons() {
  trainButton.update();
  if (trainButton.isActive()) {
    color dragTrainColor = color(150);
    int w = 30;
    int h = 20;
    for (Pair p : activeLine._stationEnds) {
      if ( p.getA() instanceof Connector && ((Connector)p.getA()).isNear() ) {
        dragTrainColor = activeLine.c;
        w = 40;
        h = 30;
      }
    }
    trainButton.drawCursor(w, h, dragTrainColor);
  }

  for (int i = 0; i < _buttons.size(); i++) {
    _buttons.get(i).update();
    if (_buttons.get(i).isClicked()) {
      activeTrainLine = _trainlines.get(i);
      //deactivate other buttons
      for (int j = 0; j < _buttons.size(); j++)
        if (j != i) _buttons.get(j).deactivate();
    }
  }
}

void updateTrains() { 
  for (Train tr : _trains) {
    tr.update();
  }
}

void updateTrains(int flag) { 
  for (Train tr : _trains) {
    tr.update(0);
  }
}

void updateClock() {
  int initDay = gameClock.getDay();
  gameClock.update();
  int postDay = gameClock.getDay();
  if (initDay != postDay) { //if the day just changed in gameClock
    genStation();
  }
}
void updateClock(int flag) {
  int initDay = gameClock.getDay();
  gameClock.update(0);
  int postDay = gameClock.getDay();
  if (initDay != postDay) { //if the day just changed in gameClock
    genStation();
  }
}

// =======================================
// Helper Methods
// =======================================
void updateDrag() {
  if (mousePressed && _mousePressed) { // Mouse is being pressed.
    // CASE 1: Mouse was pressed before, and being held down now.     
    for (int i = 0; i < _selectedStations.size(); i++) {
    }
    if (!_lock) mouseListenStation();
  }
}

//assumes I have an deque of stations and things to draggables to process
void executeSelected() {
  println("executing " + _selectedStations.size());
  while (_selectedStations.size() > 1) {
    //CASE 1: ADDING TO TERMINAL
    //move back until we get to a point where we can start building from. 
    if (dragType == 1) {
      //we're adding to terminal: find where we diverge from train line.
      Stack<Station> toDelete = new Stack<Station>();
      //pop em (the stations that are in the region of interest that are also on trainline) off into a stack for removal by terminal.
      //last one isn't actually selected - pop it back on after.
      while (activeTrainLine.indexOf(_selectedStations.peekFirst()) != -1) {
        toDelete.push(_selectedStations.pollFirst());
        println("pushing thing");
      }
      //last one isn't actually to be deleted, just pop it back on
      _selectedStations.addFirst(toDelete.pop());
      //remove stations
      while (toDelete.size() != 0) {
        println("POPPING OFF STATIONS");
        activeTrainLine.removeTerminalStation(toDelete.pop());
      }
      if (_selectedStations.size() <= 1) break;
      activeTrainLine.addTerminal(_selectedStations.pollFirst(), _selectedStations.peekFirst());
      println("we made it");
      //first few should be removing?
    }

    //CASE 2: ADDING MIDWAY
    if (dragType == 2) {
      println("HEYO" + _selectedStations.size());
      for (int i = 0; i < _selectedStations.size(); i++) {
        //  println(_selectedStations.(i));
      }

      //so essentially, like above, but using beginning AND end
      Stack<Station> toDeleteLeft = new Stack<Station>();
      Stack<Station> toDeleteRight = new Stack<Station>();
      //copying above code structure and praying it works
      while (activeTrainLine.indexOf(_selectedStations.peekFirst()) != -1 && _selectedStations.size() > 1) {
        println("pushed left");
        toDeleteLeft.push(_selectedStations.pollFirst());
      }
      while (activeTrainLine.indexOf(_selectedStations.peekLast()) != -1) {
        println("pushed right");
        toDeleteRight.push(_selectedStations.pollLast());
      }
      _selectedStations.addFirst(toDeleteLeft.pop());
      _selectedStations.addLast(toDeleteRight.pop());
      while (toDeleteLeft.size() != 0) {
        activeTrainLine.removeStation(toDeleteLeft.pop());
      }
      while (toDeleteRight.size() != 0) {
        activeTrainLine.removeStation(toDeleteRight.pop());
      }
      if (_selectedStations.size() <= 2) break;
      Connector activeConnector = (Connector)_selected.peekFirst();
      while (_selectedStations.size() > 2) {
        activeTrainLine.addStation(_selectedStations.pollFirst(), _selectedStations.peekLast(), _selectedStations.peekFirst(), activeConnector);
        //reset activeConnector to connector between the peekFirst() and the peekLast():
        activeConnector = activeTrainLine.findCommon(_selectedStations.peekFirst(), _selectedStations.peekLast());
      }
    }

    /*
   Draggable first = _selected.poll();
     Draggable second = _selected.peekFirst();
     Station firstStation = _selectedStations.poll();
     Station secondStation = _selectedStations.peekFirst();
     // If Terminal
     if (dragType == 1) {
     Terminal tmp = (Terminal)first;
     activeTrainLine.addTerminal(firstStation, secondStation);
     println("EXECUTE: JOIN!"); // Debugging
     }
     
     // If Connector
     else if (dragType == 2) {
     Station lastStation = _selectedStations.peekLast();
     Connector tmp = (Connector)first;
     activeTrainLine.addStation(firstStation, 
     lastStation, 
     secondStation, 
     tmp);
     println("EXECUTE: CRY!"); // Debugging
     }
     
     println("EXECUTED"); // Debugging
     }
     */
  }
}


boolean mouseListenStart() {
  boolean flag = false;
outer:
  for (TrainLine tl : _trainlines) { // Looks through all the TrainLines
    // Procedure: Check Draggable
    //            Try hashing if near mouse
    //            If hash success, add it to list of selected
    //            Otherwise, keep checking

    // Pairs -- Connectors
    for (Pair p : tl.getStationEnds()) {
      Draggable A = p.getA();
      Draggable B = p.getB();
      if (A != null && A.isNear())
        if (_hashed.add(A)) {
          _selected.add(A);
          if (A instanceof Terminal) {
            _selectedStations.add(((Terminal)A).getStation());
            dragType = 1;
          } else {
            Connector tmp = (Connector)A;
            _selectedStations.add(tmp.getStart());
            _selectedStations.add(tmp.getEnd());
            dragType = 2;
          }
          flag = true;
          break outer;
        }
      if (B != null && B.isNear())
        if (_hashed.add(B)) {
          _selected.add(B);
          if (B instanceof Terminal) {
            _selectedStations.add(((Terminal)B).getStation());
            dragType = 1;
          } else {
            Connector tmp = (Connector)B;
            _selectedStations.add(tmp.getStart());
            _selectedStations.add(tmp.getEnd());
            dragType = 2;
          }
          flag = true;
          break outer;
        }
    }
  }
  if (flag && _selected.size() == 1) activeTrainLine = _selected.getFirst().getTrainLine();
  return flag; // Nothing Detected
}

//precond: mouseListenStart() has been run, there is a train line of concern.
boolean mouseListenStation() {
  boolean lockFlag = false;
  for (Station s : _stations) {
    //process based on if in trainLine or not, if in activeConcern or not.
    if (s.isNear()) {
      lockFlag = true;
      //case 1: already of interest - only take action if at end of deque (last done thing)
      if (_selectedStations.contains(s)) {
        if (!justDraggedOnto) {
          if (dragType == 1) {
            if (_selectedStations.peekLast() == s) {
              if (_selectedStations.size() > 1) {
                _selectedStations.pollLast();//remove
                _selected.pollLast();
                justDraggedOnto = true; //prevent immediate readding
              } else {
                _selectedStations.addFirst(s);
                justDraggedOnto = true;
              }
            }
          } else { //we workin w/ connectors nao bois
            if (_selectedStations.peekFirst() == s || _selectedStations.peekLast() == s) {
              //we're passing over something of concern that we use as a leveraging point later (not actually disconnect). disconnect it, and get the next item.
              println("something's actually happening");
              if (_selectedStations.peekFirst() == s) {
                println("we're removing first");
                Station temp  = _selectedStations.pollFirst();
                Station forward = _selectedStations.peekFirst();
                _selectedStations.addFirst(temp);
                _selectedStations.addFirst(activeTrainLine.otherAdjacent(temp, forward));
                justDraggedOnto = true;
              } else {
                println("we're removing last");
                Station temp = _selectedStations.pollLast();
                Station prev = _selectedStations.peekLast();
                _selectedStations.add(temp);
                _selectedStations.add(activeTrainLine.otherAdjacent(temp, prev));
                justDraggedOnto = true;
              }
              println(_selectedStations.size());
            } else {
              //now we have deselection of some of the things involved. our area thing is right before peekLast(). So if we want to remove, we check if its location is one before peekLast to see if it's legal to remove.
              Station trackLast = _selectedStations.pollLast();
              if (_selectedStations.peekLast() == s) {
                if (_selectedStations.size() > 1) {//there's still at least 2 things to drag over.
                  _selectedStations.pollLast();
                  justDraggedOnto = true;
                } else {
                  //we going way back now
                  _selectedStations.addFirst(s);
                  justDraggedOnto = true;
                }
              }
              _selectedStations.add(trackLast);
            }
          }
        } else {
          println("but it's locked");
        }
      }
      //case 2: new station???
      else {
        //case 2a: is it not on the trainline: add
        if (!justDraggedOnto) {
          if (activeTrainLine.indexOf(s) == -1) {
            println("THIS IS A NEW STATION???");
            justDraggedOnto = true;
            //CASE: ADDING TO TERMINAL:
            if (dragType == 1) {  
              _selectedStations.add(s);  
              _selected.add(new Connector(_selectedStations.peekLast(), s, activeTrainLine));
              _selected.peekLast().setState(0);
            }
            //CASE: ADDING TO CONNECTOR
            else {
              Station tmp = _selectedStations.pollLast();
              _selectedStations.add(s);
              _selectedStations.add(tmp);
            }
          } else {//remove
            //is it on the stationline???
            //if so, check if it's active (editable) - either end of the _selectedStations - if so
            //we insert the next thing @ the first index
            if (dragType == 1) {
              if (//the current station is adjacent to the first selected station - presumably not already in the selection set, because we account for that above.
                activeTrainLine.isAdjacent(_selectedStations.peekFirst(), s)) {
                _selectedStations.addFirst(s);
              }
              //_selected.peekLast().setState(-1);
            }
          }
        }
      }
    }
  }
  if (!lockFlag) {
    justDraggedOnto = false;
    //println("not near any station (justDraggedOnto is false)");
  }
  return false;
}

// ==================================================
// Key Listeners
// ==================================================
void keyPressed() {
  char pressed = key;
  println("PRESSED: " + pressed);
  if (pressed == 'd' || pressed == 'D') {
    genStation();
  }
  if (pressed == 'p' || pressed == 'P') {
    if (_paused)
      _paused = false;
    else
      _paused = true;
  }
  // _trainlines.get(0).addTerminal(_trainlines.get(0).getStation(0), _stations.get(_stations.size() - 1)); // Debugging
}

void mousePressed() {
  if (mouseListenStart()) { // Track what was just clicked.
    println("ADDED! " + _hashed.size()); // Debugging
    println("found on mouseclick");
  } else {
    println("locking");
    _lock = true; // If nothing was clicked, lock the Deque
  }
  _mousePressed = true;
  println("MOUSE STATE : PRESSED"); // Debugging
}

void mouseReleased() {
  // Mouse is not being pressed.
  executeSelected(); // Execute selected items.
  _lock = false; // Unlock the mouse.
  _hashed.clear(); // Clear the hashset.
  _selected.clear(); // Clear the deque of selected items.
  _hashedStations.clear();
  _selectedStations.clear();
  // END CASE 3
  _mousePressed = false;
  activeTrainLine = null;
  dragType = 0;
  println("MOUSE STATE : UNPRESSED"); // Debugging
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
  // voids station and everything immediately next to it as spots for future stations...
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

public void buttonSetup() {
  int colorStartX = 500; //where color buttons start filling in (leftmost point)
  int trainStartX = 200; //train button location, trainStartX on left, so it should be < colorStartX
  int buttonY = 550; //what y level buttons fill in

  trainButton = new ButtonMovable( trainStartX, buttonY, 5, 60, 30, color(110));
  _buttons.add(new Button( colorStartX + (10), buttonY, 40, 20, _trainlines.get(0).c));
  _buttons.get(0).activate();

  //for (int i = 0; i < _trainlines.size(); i++) { //trainline color buttons
  // _buttons.add( new Button( colorStartX + (i * 10), buttonY, 40, 20, _trainlines.get(i).c) );
  //}

  //_buttons.add( new ButtonMovable( trainStartX, buttonY, 5, 60, 30, color(110, 110, 110)) );
}