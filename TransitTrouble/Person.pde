/*************************************
 * Person Class 
 * People travelling across the main map.
 *************************************/
 
public class Person implements Comparable {
  // =======================================
  // Instance Variables
  // =======================================
  int _priority;
  int _shape; // 0 to 6
  
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
       if (getPriority() > ((Person)person).getPriority())
         return 1;
       else if (getPriority() < ((Person)person).getPriority())
         return -1;
       else
         return 0;
     }
     return -1;
   }
}