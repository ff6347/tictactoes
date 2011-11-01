
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
String keys [];
String ul_url = ""; // the URL for the upload
String scores_url = "";
int whosTurn = 1;// this is the players turn 
int gameoveranim = 0;
boolean gameover = false; // the name says all
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

String labelStrings[] = new String[6]; // these are some messages


// **************************
// THE SETUP
// **************************
void setup(){
  size(1280,360);
  smooth();
  cP5 = new ControlP5(this);
  background(0);
  
    // the labels messages  
    labelStrings [0] = "Its Player ones turn";
    labelStrings [1] = "Its Player twos turn";
    labelStrings [2] = "Could not read from server going to local mode";
    labelStrings [3] = "Player 1 has won!";
    labelStrings [4] = "Player 2 has won!";
    labelStrings [5] = "Welcome";

     keys  = loadStrings("private.txt"); // sry got to keep this private
     ul_url  = keys[1]; // this is the url for the Upload.php to the server see postToWeb lib by seltar
     scores_url = keys[0];// this is the url for the scores file

  // the font on the lamps numbers
  font = createFont("DejaVuSansMono",12);
  
  // initalize the Sectors
  for(int i = 0; i < sectors.length; i++){
  sectors[i] = new Sector();
  }
  
  
// build the lamps on their place 
int ctr = 0;
  for(int y = 0; y < 256; y +=32 ){
    for(int x = 0; x < 256; x+=32){
    matrix[ctr] = new Lamp(x,y,10,ctr);
    ctr++;
    }
  }
  
  // this combines the inner lamps to 9 different sectors
    for(int j = 0; j < matrix.length; j++){
    initSectors(j ,sectors[0],matrix,9, 10, 17, 18);
    initSectors(j ,sectors[1],matrix,11, 12, 19, 20);
    initSectors(j ,sectors[2],matrix,13, 14, 21, 22);
    initSectors(j ,sectors[3],matrix,25, 26, 33, 34);
    initSectors(j ,sectors[4],matrix,27, 28, 35, 36);
    initSectors(j ,sectors[5],matrix,29, 30, 37, 38);
    initSectors(j ,sectors[6],matrix,41, 42, 49, 50);
    initSectors(j ,sectors[7],matrix,43, 44, 51, 52);
    initSectors(j ,sectors[8],matrix,45, 46, 53, 54);
    }
   
// ad some controllers
  cP5.addButton("read",0,100,100,80,19);
  cP5.addButton("write",0,100,120,80,19);
  cP5.addButton("newgame",0,100,140,80,19);
// the messages
  textLabel = cP5.addTextlabel("label",labelStrings[5],100,70);
  textLabel.setColorValue(0xffcccccc);
  
  // now build some bangbuttons for selection off the lamp
  // this will be on the arduino
    int off1Y = 0;
    int off1X = 0;
     int off2Y = 0;
    int off2X = 0;
    
  for(int i=0;i< 9;i++) {
    
    if(i > 2 && i < 6){
    off1Y = 40;
    off1X = -150;
    off2Y = 40;
    off2X = -150;
    }else if(i > 5){
    off1Y = 80;
    off1X = -300;
    off2Y = 80;
    off2X = -300;
    }
    
    cP5.addBang("bang"+i,width/2 + i* 50 + off1X, 100 +off1Y,20,20).setId(i);
    cP5.addBang("bang"+(i+9),(width/3)*2 + i* 50 + off2X, 100 +off2Y,20,20).setId(i+9);

  }
  
  // read from server
  // the fallback local mode is not implemented
  // needs something like creating a mail with the scores.txt attached
  
try{
  read();// this reads the scores from the server
  }catch(Exception e){
  textLabel.setValue(labelStrings[2]);
  }

}// close setup

// **************************
// END THE SETUP START THE DRAW
// **************************

void draw(){
  
//  println(ply1Wins);
  background(0);
  // push the lamps around
  pushMatrix();
  translate(width/4,height/4);
  // you could also do that for the sectors
  for(int j = 0;  j< matrix.length;j++){
    matrix[j].display();
  }
  
  popMatrix();
  //fill(buttonVal);
  //rect(20,20,width-40,height-40);

// tell whos turn it is
if(whosTurn == 1){
textLabel.setValue(labelStrings[0]);
}else if (whosTurn == 2 ){
textLabel.setValue(labelStrings[1]);
}

// this checks all the sectors for winners
checkSectors();

//  the game is over
  if(gameover){
    matrix[gameoveranim].val = 3;
    delay(100);
    gameoveranim++;
    if(gameoveranim > matrix.length-1){
    gameoveranim = 0;
    if(theWinner ==1){
    ply1Wins++;
    }else if(theWinner == 2){
    ply2Wins++;
    }
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
          if(sectors[theEvent.controller().id()-9].secval == 0 && whosTurn == 2){
          sectors[theEvent.controller().id()-9].setSectorVal(2);
          whosTurn = 1;
          }
    }else{
          if(sectors[theEvent.controller().id()].secval == 0 && whosTurn == 1){
          sectors[theEvent.controller().id()].setSectorVal(1);
          whosTurn = 2;
          }
    }
}// close controll event

// function buttonA will receive changes from 
// controller with name buttonA
// it reads in the values from the textfile
public void read() {
  

  
  
   scores = loadStrings(scores_url);// this could also be a local file but here it is hidden on a server
  
  
  // scores = loadStrings("scores.txt"); 
  whosTurn =  Integer.parseInt(scores[0]);
  ply1Wins = Integer.parseInt(scores[1]);
  ply2Wins = Integer.parseInt(scores[2]);
//  println("Games Won by Player 1" + ply1Wins +"\n"
//  +"Games Won by Player 2" + ply2Wins +"\n");
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
  scores [0] = whosTurn +"";
  scores [1] = ply1Wins+"";
  scores [2] = ply2Wins+"";
  for(int i = 3; i < scores.length ; i++){
  scores [i] = sectors[i -3].secval +"";
  
  }
  // write the results to the textfile
 saveStrings(dataPath("scores.txt"), scores);
 
 // this is the postToWeb Lib by seltar
     ByteToWeb bytes = new ByteToWeb(this);
    String uploadText = join(scores,"\n");
    bytes.post("test",ul_url,"scores.txt",true,uploadText.getBytes());
    
    
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

// there are 8 possibilitys how to win
  
// 1  2  3
// 4  5  6
// 7  8  9
// 
// 
// read in all values from the 9 sectors
int secVals [] = new int [sectors.length];
for (int i = 0; i < secVals.length; i++){
secVals[i] = sectors[i].secval;
}

// this checkes for all possibilitys to win for both players 
// each frame
//for(int j = 1; j < 3; j ++){
  // 1, 2,3
testPossibility(secVals,0,1,2, 1,labelStrings[1+2]);
// 456
testPossibility(secVals,3,4,5,1,labelStrings[1+2]);
// 789
testPossibility(secVals,6,7,8,1,labelStrings[1+2]);
//147
testPossibility(secVals,0,3,6,1,labelStrings[1+2]);
//258
testPossibility(secVals,1,4,7,1,labelStrings[1+2]);
//369
testPossibility(secVals,2,5,8,1,labelStrings[1+2]);
//159
testPossibility(secVals,0,4,8,1,labelStrings[1+2]);
//753
testPossibility(secVals,6,4,2,1,labelStrings[1+2]);

//player 2
//123
testPossibility(secVals,0,1,2, 2,labelStrings[2+2]);
// 456
testPossibility(secVals,3,4,5,2,labelStrings[2+2]);
// 789
testPossibility(secVals,6,7,8,2,labelStrings[2+2]);
//147
testPossibility(secVals,0,3,6,2,labelStrings[2+2]);
//258
testPossibility(secVals,1,4,7,2,labelStrings[2+2]);
//369
testPossibility(secVals,2,5,8,2,labelStrings[2+2]);
//159
testPossibility(secVals,0,4,8,2,labelStrings[2+2]);
//753
testPossibility(secVals,6,4,2,2,labelStrings[2+2]);
//}
 
}


// this checkes for the possible wins
void testPossibility(int secVals[], int a,int b, int c, int ply,String msg){
if((secVals[a]  == ply)&&(secVals[b]  == ply)&&(secVals[c]  == ply)){
textLabel.setValue(msg);
theWinner = ply;
gameover = true;
}


}


// this combines 4 lamps into a sector
void initSectors(int i ,Sector sector, Lamp matrix [],int a, int b, int c, int d){

    if((i == a) || (i == b)||(i == c)||(i == d)){
    sector.addLampToSector(matrix[i]);
    }
}
