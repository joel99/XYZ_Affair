/*************************************
 * Person Class 
 * People travelling across the main map.
 *************************************/

public class Person implements Comparable {
  // =======================================
  // Instance Variables
  // =======================================
  int _priority; // 0 to 2 (Maybe more?)
  int _shape; // 0 to 6

  // =======================================
  // Default Constructors
  // =======================================
  Person() {
    _priority = 0; // Lowest Priority 
    _shape = int(random(3)); // Replace with randomShape() later;
  }
  Person(int priority, int shape) {
    this();
    _priority = priority;
    _shape = shape;
  }

  /** randomShape() - Returns a random integer from 0 to 6
   * precond:
   * postcond: _shape is set to an integer in the range [0, 6] */
  int randomShape() {
    return int(random(7));
  }

  // =======================================
  // Mutators and Accessors
  // ======================================= 
  /** getPriority() 
   * returns priority of this person */
  int getPriority() {
    return _priority;
  }

  /** getShape()
   * returns shape of this person */
  int getShape() {
    return _shape;
  }

  // =======================================
  // Compare To - Compares people based on priority
  // =======================================
  /** compareTo(Object) - Racism, basically
   * precond: Object is a Person
   * postcond: 1 if this has higher priority than the parameter's priority
   *           0 if this person has the same priority
   *          -1 if this person has lower priority */
  public int compareTo(Object person) {
    if (person instanceof Person) {
      if (this.getPriority() > ((Person)person).getPriority())
        return 1;
      else if (this.getPriority() < ((Person)person).getPriority())
        return -1;
      else
        return 0;
    }
    return -1;
  }
}