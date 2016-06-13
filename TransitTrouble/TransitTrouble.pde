/*************************************
 * Transit Trouble by XYZ Affair 
 *************************************/
//NOTE: SCREEN RATIO 3:2
import java.util.ArrayDeque;
import java.util.HashSet;

ArrayList<Train> _trains = new ArrayList<Train>();
ArrayList<Station> _stations = new ArrayList<Station>(); // List of active Stations
ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>(); // List of active Trainlines
ArrayList<Button> _buttons = new ArrayList<Button>(); //List of ingame buttons 

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

TrainLine activeLine;

// Game Map - GUI

Map map = new Map();

void setup() {
  smooth(4);
  strokeWeight(8);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change

  // ==================================================
  // Debugging
  for (int i = 0; i < 1; i++) {
    genStation();
  }
  _trainlines.add(new TrainLine(_stations.get(0)));
  
  activeLine = _trainlines.get(0); //TEMPORARY
  
  genStation();
  _trainlines.get(0).addTerminal(_stations.get(0), _stations.get(1));

  buttonSetup();

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

void draw() {
  background(255, 255, 255);

  map.debug(); //Debugging - Maps red dots to each grid coordinate
  //stroke(255);
  fill(255);
  
  //ellipse(mouseX, mouseY, 40, 40);      <-- Hollow circle cursor
  
  buttonSetup(); //when more train lines get added
  
  for (TrainLine tl : _trainlines) {
    tl.update();
  }
  for (Station s : _stations) {
    s.update();
    textSize(16); // Debugging
    fill(0); // Debugging
    text(_stations.indexOf(s), s.getX(), s.getY()); // Debugging
  }
  for (Button b : _buttons) {
    b.update();
    if (b instanceof ButtonMovable && ((ButtonMovable)b).isActive()) {
      color dragTrainColor = color(150, 150, 150);
      int w = 30;
      int h = 20;
      for (Pair p : activeLine._stationEnds) {
        if ( p.getA() instanceof Connector && ((Connector)p.getA()).isNear() ) {
          dragTrainColor = activeLine.c;
          w = 40;
          h = 30;
        }
      }
      ((ButtonMovable)b).drawCursor( w, h, dragTrainColor );
    }
  }
  for (Train tr : _trains) {
    tr.update();
  }

  updateDrag(); // Dragging Mechanism
}

void updateDrag() {
  if (mousePressed && _mousePressed) { // Mouse is being pressed.
    // CASE 1: Mouse was pressed before, and being held down now.     
    for (int i = 0; i < _selectedStations.size(); i++) {
    }
    if (_lock)
      println("MOUSE STATE: LOCKED"); // Debugging
    else mouseListenStation();
  }
}

//assumes I have an deque of stations and things to draggables to process
void executeSelected() {
  println(_selectedStations.size());
  while (_selectedStations.size() > 1) {
    //CASE 1: ADDING TO TERMINAL
    //move back until we get to a point where we can start building from. 
    //while(_selectedStations.peekFirst() == o){}
    if (dragType == 1) {
      //we're adding to terminal: find where we diverge from train line.
      //ArrayList<Station> toDeleteStations = new ArrayList<>();
      //toDelete
      activeTrainLine.addTerminal(_selectedStations.pollFirst(), _selectedStations.peekFirst());

      //first few should be removing?
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
          println("selected connect");
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
          println("selected connect");
          flag = true;
          break outer;
        }
    }
  }
  //println("stuff is exec");
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
      println("we're near some station");
      //case 1: already of interest - only take action if at end of deque (last done thing)
      if (_selectedStations.contains(s)) {
        println("we're near a station that is already of interest");
        if (!justDraggedOnto) {
          println("hum, this is interesting");
          if (_selectedStations.peekLast() == s) {
            println("POP IT OFF");
            _selectedStations.pollLast();//remove
            _selected.pollLast();
            justDraggedOnto = true; //prevent immediate readding
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
            _selectedStations.add(s);
            println(_selectedStations);
            //CASE: ADDING TO TERMINAL:
            if (dragType == 1) {

              _selected.add(new Connector(_selectedStations.peekLast(), s, activeTrainLine));
              _selected.peekLast().setState(0);
            }
          } else {//remove
            
          
            if (dragType == 1) {
              _selected.peekLast().setState(-1);
            }
          }
        }
      }
    }
  }
  if (!lockFlag) {
    justDraggedOnto = false;
    println("not near any station (justDraggedOnto is false)");
  }
  return false;
}

// ==================================================
// Helper Methods
// ==================================================
void keyPressed() {
  println("LMAO");
  genStation();
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
  for (Train tr : _trains) {
    tr.recalc();
  }
}



public void buttonSetup() {
  int colorStartX = 500; //where color buttons start filling in (leftmost point)
  int trainStartX = 200; //train button location, trainStartX on left, so it should be < colorStartX
  int buttonY = 550; //what y level buttons fill in

  for (int i = 0; i < _trainlines.size(); i++) { //trainline color buttons
    _buttons.add( new Button( colorStartX + (i * 10), buttonY, 40, 20, _trainlines.get(i).c) );
  }

  _buttons.add( new ButtonMovable( trainStartX, buttonY, 5, 60, 30, color(110,110,110)) );
}