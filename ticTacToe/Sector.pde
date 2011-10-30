class Sector{
  
  int secval = 0;
  boolean used = false;
  ArrayList <Lamp> lamps = new ArrayList <Lamp>();
    Sector(){
    
    }
  
  
  void addLampToSector(Lamp l){
  
  lamps.add(l);
  }
  
  void display(){
  
  for (int i = 0; i < lamps.size(); i++){
    
    lamps.get(i).display();
    }

  }
  

void setSectorVal(int val){
  if(used == false){
    
    for (int i = 0; i < lamps.size(); i++){
    
    lamps.get(i).val = val;
    }
    
    secval = val;
  }// closed used
}
  
 
}// close setSectorVal()
