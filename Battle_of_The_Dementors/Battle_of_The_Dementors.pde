/* adapted from "BouncyBubbles" example
   Created by @Matthew Gonzalez, UHD ID: 1620664
   
   Game is played by pressing spacebar to start the game. 
*/




import processing.sound.*;
SoundFile introSong;
SoundFile playSong;
SoundFile outroSong;

PImage mainMenu, playerScreen, passedGame, failed, moveLeft, moveRight, patronus, dementor, chocolate;

int numBubbles = 1; //initial dementor count
final int BROKEN = -99; // code for "broken", may have other states later
final int MAXDIAMETER = 120; // maximum size of expanding bubble

ArrayList pieces; // all the playing pieces

// Game Resources
int patronusCharms = 15;
int dementors = 1;
int chocolates = 2; 
int gameStart; 
int startingTime = 30;
int remainingTime = 30;
int timeSpent = 0;
int pauseTime;    
int score = 0;
int highScore = -99999;

PFont font;

public enum statusOfGame {
  homeScreen, gameScreen, savedSirius, failedGame
}

statusOfGame gameStatus;

void setup() {
  size(1616, 909);
  noStroke();
  smooth();
  
  introSong = new SoundFile(this, "01. John Williams - Lumos! (Hedwig's Theme)_sample.mp3");
  introSong.loop();
  
  mainMenu = loadImage("HogwartsGameScreen.png");
  playerScreen = loadImage ("screen1.jpeg");
  passedGame = loadImage ("HarryPotterPassed.png");
  failed = loadImage ("HarryPotterFailed.png");
  
  moveLeft = loadImage ("harryLeft.png");
  moveRight = loadImage ("harryRight.png");
  dementor = loadImage ("Dementor.png");
  chocolate = loadImage ("chocolateBar.png");
  patronus = loadImage ("Patronus");
  
  //font = createFont("HARRYP__.TTF");
  
  gameStatus = statusOfGame.homeScreen;
  
 //number of images to load for sprite animation
 
 
}

void start() {
   patronusCharms = 20;
   chocolates = 2; 
   startingTime = 25;
   remainingTime = 25;
   numBubbles = 20;
  
  pieces = new ArrayList(numBubbles);
  for (int i = 0; i < numBubbles; i++) {
    float bubbleType = random(0, 3);
    pieces.add(new Bubble(random(100, width-100), random(100, height-100), 30, i, pieces, bubbleType, false));
  }
  //start timer
  gameStart = millis();
  gameStatus = statusOfGame.gameScreen;

}
  


void draw() {
  //background images: homeScreen, playerScreen, passedGame, failed, moveLeft, moveRight, dementor, chocolate;
  //Game Statuses: homeScreen, gameScreen, savedSirius, failedGame
  background(mainMenu);
  
  //switch cases for status of the game
  switch(gameStatus) {
  case homeScreen:
    background(mainMenu);
    break;
  case savedSirius:        
    background(passedGame);
    pieces.clear();
    break;
  case failedGame:        
    background(failed);
    this.pieces.clear();
    break;
  case gameScreen:
  background(playerScreen);
 

    //starting the game timer
    if (startingTime > 0)  
      startingTime = remainingTime - (millis() - gameStart)/1000;
      if (startingTime < 1) {      
      /*int t = (20-patronusCharms) * 50;
      int d = dementors * 100;
      score = -t + d;*/
      if (numBubbles <= 20)
        gameStatus = statusOfGame.savedSirius;
      else
        gameStatus = statusOfGame.failedGame;
      if(score > highScore)
        highScore = score;
    } 
    else {     
      for (int i = 0; i < numBubbles; i++) {
        Bubble b = (Bubble)pieces.get(i); 

        if (b.diameter < 1) {        
          pieces.remove(i);
          numBubbles--;
          i--;

          if (!b.mouseClick) {
            if (b.bubbleType < 2)
              dementors++;
           
          }
        } else {
         
          if (b.broken == BROKEN)
            b.collide();

          b.update();
          b.display();
        }
      }
    }
      //if (numBubbles < 1)
        //gameStatus = statusOfGame.savedSirius;
      //else
        //gameStatus = statusOfGame.failedGame;
  break;
    } 
  } 
  
void mousePressed() {  
  if (patronusCharms > 0) {
    patronusCharms --;   
    Bubble b = new Bubble(mouseX, mouseY, 2, numBubbles, pieces, -1, true);
    b.burst();
    pieces.add(b);
    numBubbles++;
  }
  }
  
  void keyPressed() {
    
  if (key == ' ' && ( gameStatus == statusOfGame.homeScreen ||gameStatus == statusOfGame.savedSirius || gameStatus == statusOfGame.failedGame)) { 
    start();
    }
  }
