
// ticTacToe
// this will be controlling some leds and an pontentiometer
// on a arduino board

// Copyright (C) 2011 Fabian "fabiantheblind" Morón Zirfas
// http://www.the-moron.net
// info [at] the - moron . net

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/


import controlP5.*; // for the GUI
import org.seltar.Bytes2Web.*; // for saving on the server


/*
// the scores layout
Whos turn it is:int (1 or 2)
Player1:        int (number of wins)
Player2:	int (number of wins)
sector1:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector2:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector3:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector4:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector5:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector6:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector7:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector8:	int 0 (off) ,1 (red),2 (green),3 (yellow)
sector9:	int 0 (off) ,1 (red),2 (green),3 (yellow)

*/

int player = 1;// this is the players turn 
int gameoveranim = 0;
  boolean gameover = false;
int theWinner = 0;// this is the winner


int ply1Wins = 0;// how many wins

int ply2Wins = 0;// how many wins

PFont font; // the font for the lamps
// this is the file that holdes all the data
String scores [] = new String [12];
// a lamp is just a point that can turn red green, white or yellow
// we got 64 lamps the outer row is just for feedback
// the inner ones are the tic tac toe

// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  
// 0  0  0  0  0  0  0  0  

Lamp matrix [] = new Lamp [64];

// for the gui
ControlP5 cP5;

// the text that says whats going on
Textlabel textLabel;

// this is the sectors.
// its a 3 by 3 Matrix of 4 LEDs each
Sector sectors [] = new Sector [9];



// **************************
// THE SETUP
// **************************
void setup(){
  frameRate(30);
  // the font on the lamps
  font = createFont("DejaVuSansMono",12);
  
  // initalize the Sectors
  for(int i = 0; i < sectors.length; i++){
  sectors[i] = new Sector();
}
  
  
  // now combine the lamps into sectors
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
    background(0);

  cP5.addButton("read",0,100,100,80,19);
  cP5.addButton("write",0,100,120,80,19);
    cP5.addButton("newgame",0,100,140,80,19);

textLabel = cP5.addTextlabel("label","Its Player ones turn",100,70);
  textLabel.setColorValue(0xffcccccc);

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

// **************************
// END THE SETUP START THE DRAW
// **************************

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


if(player == 1){
textLabel.setValue("Its Player ones turn");
}else if (player ==2 ){
textLabel.setValue("Its Player twos turn");
}

checkSectors();

  if(gameover){
    //int preVal = matrix[gameoveranim].val;
    matrix[gameoveranim].val = 3;
    delay(100);
    //matrix[gameoveranim].val = preVal;
    gameoveranim++;
    if(gameoveranim > matrix.length-1){
    gameoveranim = 0;
    gameover = false;
    newgame();
    write();
    }
  }
}// close draw


// **************************
// END THE DRAW
// **************************


public void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().name());
  
    if(theEvent.controller().id() > 8){
          if(sectors[theEvent.controller().id()-9].secval == 0 && player == 2){
          sectors[theEvent.controller().id()-9].setSectorVal(2);
          player = 1;
          }
    }else{
          if(sectors[theEvent.controller().id()].secval == 0 && player == 1){
          sectors[theEvent.controller().id()].setSectorVal(1);
          player = 2;
          }
    }
}// close controll event

// function buttonA will receive changes from 
// controller with name buttonA
// it reads in the values from the textfile
public void read() {
  
//  String key [] = loadStrings("private.txt")
//  String lines[] = loadStrings(key[0]);

   scores = loadStrings("scores.txt");
//   scores = loadStrings("Desktop/scores.txt");
   
  player =  Integer.parseInt(scores[0]);
  ply1Wins = Integer.parseInt(scores[1]);
  ply2Wins = Integer.parseInt(scores[2]);

//println("there are " + lines.length + " lines");
for (int i=0; i < scores.length; i++) {
  println(scores[i]);
  if(i > 2){
      sectors[i - 3].setSectorVal( Integer.parseInt(scores[i]));
    }
  }// close i loop

}// close read

// function buttonB will receive changes from 
// controller with name buttonB
// writes the values to the textfile
public void write() {
  println("a button event from write");
  scores [0] = player +"";
  scores [1] = ply1Wins+"";
  scores [2] = ply2Wins+"";
  for(int i = 3; i < scores.length ; i++){
  scores [i] = sectors[i -3].secval +"";
  
  }
  // write the results to the textfile
 saveStrings(dataPath("scores.txt"), scores);
// saveStrings("/Desktop/scores.txt", scores);
 



}// close write


public void newgame(){
  
    println("a button event from newgame");

for(int i = 0; i < sectors.length; i++){
    sectors[i].setSectorVal(0);
  }
for(int j = 0; j < matrix.length; j++){
    matrix[j].val = 0;
  }  
  
}

void checkSectors(){
theWinner = 0;
int secVals [] = new int [sectors.length];
for (int i = 0; i < secVals.length; i++){
secVals[i] = sectors[i].secval;
}

String ply1Won = "player one has won!!!";
// player 1 chances
// sec 1, 2,3
if((secVals[0]  == 1)&&(secVals[1]  == 1)&&(secVals[2]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;

}
// 456
if((secVals[3]  == 1)&&(secVals[4]  == 1)&&(secVals[5]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;


}
// 789
if((secVals[6]  == 1)&&(secVals[7]  == 1)&&(secVals[8]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;


}
//147
if((secVals[0]  == 1)&&(secVals[3]  == 1)&&(secVals[6]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;


}
//258
if((secVals[1]  == 1)&&(secVals[4]  == 1)&&(secVals[7]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;


}
//369
if((secVals[2]  == 1)&&(secVals[5]  == 1)&&(secVals[8]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;


}
//159
if((secVals[0]  == 1)&&(secVals[4]  == 1)&&(secVals[8]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;
}
//753
if((secVals[6]  == 1)&&(secVals[4]  == 1)&&(secVals[2]  == 1)){
textLabel.setValue(ply1Won);
theWinner = 1;
ply1Wins++;
gameover = true;
}

String ply2Won = "player two has won!!!";
// player 1 different ways a player can win
// it could be
// 123
// 456
// 789
// 147
// 258
// 369
// 159
// 753


// sec 1, 2,3
if((secVals[0]  == 2)&&(secVals[1]  == 2)&&(secVals[2]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;


}
// 456
if((secVals[3]  == 2)&&(secVals[4]  == 2)&&(secVals[5]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
// 789
if((secVals[6]  == 2)&&(secVals[7]  == 2)&&(secVals[8]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
//147
if((secVals[0]  == 2)&&(secVals[3]  == 2)&&(secVals[6]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
//258
if((secVals[1]  == 2)&&(secVals[4]  == 2)&&(secVals[7]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
//369
if((secVals[2]  == 2)&&(secVals[5]  == 2)&&(secVals[8]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
//159
if((secVals[0]  == 2)&&(secVals[4]  == 2)&&(secVals[8]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}
//753
if((secVals[6]  == 2)&&(secVals[4]  == 2)&&(secVals[2]  == 2)){
textLabel.setValue(ply2Won);
theWinner = 2;
ply2Wins++;
gameover = true;

}  
 
}


