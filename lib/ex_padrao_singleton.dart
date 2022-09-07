class Normal{
  
  Normal(){}
  
}

class Singleton{
  
  static final Singleton _singleton =  Singleton._internal();
  
    factory Singleton(){ 
      print("Singleton");
      return _singleton;
    }
  
    Singleton._internal(){
    print("_internal");
  }
}

void main() {
  
  var i1 = Singleton();
  print("***");
  var i2 = Singleton();
  
  print(i1 == i2);
  
}
