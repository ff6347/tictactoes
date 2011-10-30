class Lamp{
  
  int sector;
  int val;
  int x; 
  int y;
  int diam;
  int ndx;

  Lamp(int x, int y,int diam, int ndx){
  this.x =x;
  this.y = y;
  this.diam = diam;
  this.ndx = ndx;
  
  }
  
  
  void display(){
    
    // the switch sets the color of the lamps
    // it reacts on val. val is the value coming in from the scores.txt
    // case 0 == white
    // case 1 == red
    // case 2 == green
    switch(val){
      
    case 0:
    fill(255);
    break;
    
    case 1:
    fill(255,0,0);
    break;
    
    case 2:
    fill(0,255,0);
    break;

    case 3:
    fill(255,255,0);
    break;
    
    }//close switch
    // draw the ellipse as lamp representation
    
    ellipse(x,y,diam,diam);
   
    fill(255);
    text(ndx,x +5,y);
  
  }// close display

}// close class lamp
