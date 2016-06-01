/*************************************
 * Transit Trouble by XYZ Affair 
 * <DESCRIPTION>
 *************************************/

ArrayList<Station> _stations = new ArrayList<Station>();

void setup() {
  background(255,255,255); // White - Subject to Change
  size(900,600); // Default Size - Subject to Change
  
  // ==================================================
  // Debugging
  for (int i = 0; i < 5; i++) {
    _stations.add(new Station(50,50,850,550));
  }
  // ==================================================
}

void draw() {
  for (Station s : _stations) {
    s.update(); 
  }
}