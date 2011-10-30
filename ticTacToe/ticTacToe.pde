/*
// the scores layout
Player1:	0,0
Player2:	0,0
sector1:	0
sector2:	0
sector3:	0
sector4:	0
sector5:	0
sector6:	0
sector7:	0
sector8:	0
sector9:	0

*/
import controlP5.*;
//ticTacToe

PFont font;

Lamp matrix [] = new Lamp [64];
ControlP5 cP5;

Sector sectors [] = new Sector [9];



int buttonVal = 0;

int c = color(0);

void setup(){
  font = createFont("DejaVuSansMono",12);
  for(int i = 0; i < sectors.length; i++){
  sectors[i] = new Sector();
}
//println(sectors.length);
  
  int ctr = 0;
  for(int y = 0; y < 256; y +=32 ){
    for(int x = 0; x < 256; x+=32){
    matrix[ctr] = new Lamp(x,y,10,ctr);
    
    if((ctr == 9) || (ctr == 10)||(ctr == 17)||(ctr == 18)){
    sectors[0].addLampToSector(matrix[ctr]);
    }else if((ctr == 11) || (ctr == 12)||(ctr == 19)||(ctr == 20)){
    sectors[1].addLampToSector(matrix[ctr]);
    }else if((ctr == 13) || (ctr == 14)||(ctr == 21)||(ctr == 22)){
    sectors[2].addLampToSector(matrix[ctr]);
    }else if((ctr == 25) || (ctr == 26)||(ctr == 33)||(ctr == 34)){
    sectors[3].addLampToSector(matrix[ctr]);
    }else if((ctr == 27) || (ctr == 28)||(ctr == 35)||(ctr == 36)){
    sectors[4].addLampToSector(matrix[ctr]);
    }else if((ctr == 29) || (ctr == 30)||(ctr == 37)||(ctr == 38)){
    sectors[5].addLampToSector(matrix[ctr]);
    }else if((ctr == 41) || (ctr == 42)||(ctr == 49)||(ctr == 50)){
    sectors[6].addLampToSector(matrix[ctr]);
    }else if((ctr == 43) || (ctr == 44)||(ctr == 51)||(ctr == 52)){
    sectors[7].addLampToSector(matrix[ctr]);
    }else if((ctr == 45) || (ctr == 46)||(ctr == 53)||(ctr == 54)){
    sectors[8].addLampToSector(matrix[ctr]);
    }
    
    
    ctr++;
    }
  }
  
   
  
  
size(1280,360);
 smooth();
  cP5 = new ControlP5(this);
    background(c);

  cP5.addButton("read",0,100,100,80,19);
  cP5.addButton("write",0,100,120,80,19);


  for(int i=0;i< 9;i++) {
    int offY = 0;
    int offX = 0;
    if(i > 2 && i < 6){
    offY = 40;
    offX = -150;
    }else if(i > 5){
        offY = 80;
       offX = -300;
    }
    cP5.addBang("bang"+i,width/2 + i* 50 + offX, 100 +offY,20,20).setId(i);
  }
  
    for(int j=0;j< 9;j++) {
    int offY = 0;
    int offX = 0;
    if(j > 2 && j < 6){
    offY = 40;
    offX = -150;
    }else if(j > 5){
        offY = 80;
       offX = -300;
    }
    cP5.addBang("bang"+(j+9),(width/3)*2 + j* 50 + offX, 100 +offY,20,20).setId(j+9);
  }
  
  

//sectors[2].setSectorVal(1);

}// close setup

void draw(){
  background(0);
  pushMatrix();
  translate(width/4,height/4);

  for(int j = 0;  j< matrix.length;j++){
//    matrix[j].val = 0;
    matrix[j].display();
  }
  
  popMatrix();
  //fill(buttonVal);
  //rect(20,20,width-40,height-40);

}// close draw

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().name());
//    for(int i=0;i<9;i++) {
//    if((theEvent.controller().label().equals("BANG"+i))) {
//      sectors[i].setSectorVal(1);
//    println( i + " A");
//    }
//    
//       if((theEvent.controller().label().equals("BANG"+(i+9)))) {
//      sectors[i].setSectorVal(2);
//    println( i + " B");
//    }
//    
//  }
//  
//
    println(
  "## controlEvent / id:"+theEvent.controller().id()+
    " / name:"+theEvent.controller().name()+
    " / label:"+theEvent.controller().label()+
    " / value:"+theEvent.controller().value()
    );
    
    if(theEvent.controller().id() > 8){
          if(sectors[theEvent.controller().id()-9].secval == 0){
          sectors[theEvent.controller().id()-9].setSectorVal(2);
          }
    }else{
              if(sectors[theEvent.controller().id()].secval == 0){

              sectors[theEvent.controller().id()].setSectorVal(1);
              }
    }
}// close controll event

// function buttonA will receive changes from 
// controller with name buttonA
public void read() {
//  println("a button event from read: "+theValue);
//  c = theValue;
  
  
//  String lines[] = loadStrings("http://www.the-moron.net/project/tictactoe/test/scores.txt");
  String lines[] = loadStrings("scores.txt");

//println("there are " + lines.length + " lines");
for (int i=0; i < lines.length; i++) {
  println(lines[i]);
  if(i > 1){
      sectors[i - 2].setSectorVal( Integer.parseInt(lines[i]));
    }
  }// close i loop

}// close read

// function buttonB will receive changes from 
// controller with name buttonB
public void write() {
  println("a button event from write");
}// close write
