// 
//a custom pair class to hold L,R of stations
//not to conflate with the pair classes on the net, values are mutable
public class Pair {
  
  private Draggable _a;
  private Draggable _b;
  
  public Pair(Draggable a, Draggable b){
    _a = a;
    _b = b;
  }
  
  
  public Draggable getA(){
    return _a;
  }
  
  public Draggable getB(){
    return _b;
  }
  
  public Draggable setA(Draggable a){
    Draggable ret = getA();
    _a = a;
    return ret;
  }
  
  public Draggable setB(Draggable b){
    Draggable ret = getB();
    _b = b;
    return ret;
  }
  
  public Draggable getOther(Draggable d){
    if (d == _a)
      return _b;
    else 
      return _a;
  }
}