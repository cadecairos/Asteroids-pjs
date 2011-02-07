import processing.opengl.*;

/* ASTEROIDS PJS V 0.2
** Created By: Christopher De Cairos
**
*******************************************************************************
** Copyright (c) 2011 Christopher De Cairos
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
** 
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
** 
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
** THE SOFTWARE.
**
********************************************************************************
** Thank you for playing :) this is my first attempt at a game so the code is very 
** very inefficient and dirty. Collisions need a lot of work. Scoring soon to come, 
** as well as collisions with the player.
** 
** -Controls-
** Turn        - Left and Right Arrows
** Accellerate - Up Arrow
** Shoot       - Down Arrow / Spacebar
**
** Bug reports and suggestions can be sent to chris_decairos_(at)hotmail(dot)com
**
*/

Player p;
ArrayList bullets, asteroids;

void setup(){
 size(600,600,OPENGL); 
 p = new Player(); 
 bullets = new ArrayList();
 asteroids = new ArrayList();
}
  
void draw () {
  color c = color(0,0,0);
  background(c);
   collisionChecks();
   p.draw();
   drawBullets();
   createAsteroid();
   drawAsteroids();
}

void drawBullets(){
  for (int i = 0 ; i < bullets.size() ; i++){
     Bullet b = (Bullet)bullets.get(i);
     if(b.isOffscreen()){
       bullets.remove(i);
     }
     else{
       b.draw();
     }
   }
}

void drawAsteroids(){
  for(int i = 0; i < asteroids.size(); i++){
    Asteroid a = (Asteroid)asteroids.get(i);
    a.draw();
  }
} 

void createAsteroid(){
  if (asteroids.size() < 6){
    int create = round (random(0, 1000));
    if (create >= 998){
      int detail = round(random(4, 7));
      Asteroid a = new Asteroid(detail, 20, floor(random (1,5)), 0, 0 , 0, 0);
      asteroids.add(a);
    }
  }
}

 void keyPressed () {
   if (keyCode == 37){
     p.turn(keyCode);
   }
   else if (keyCode == 39){
     p.turn(keyCode);
   }
   else if(keyCode == 38) {
     p.accelerate();
   }
   else if (keyCode == 32 || keyCode == 40){
     p.shoot();
   }
 }  
 
 void collisionChecks() { 
   //asteroidHitPlayer(); 
   bulletHitAsteroid();
   asteroidHitAsteroid();
 }
 
 void asteroidHitAsteroid() {
   if (asteroids.size() > 1) {
     for (int i = 0; i < asteroids.size();i++) {
       Asteroid a1 = (Asteroid)asteroids.get(i);
       for (int j = i+1; j < asteroids.size();j++) {
         Asteroid a2 = (Asteroid)asteroids.get(j);
         a1.collided(a2);
       }  
     }
   }
 }
 
// void asteroidHitPlayer() {
//   for (int i = 0; i < asteroid.size(); i++) {
//     Asteroid a = asteroids.get(i);
//     if (/* check magnitude */  ) {
//       blow up player (restart game method?)
//     }
//   }
// }
 
 void bulletHitAsteroid() {
   for (int i = 0; i < asteroids.size();i++) {
     Asteroid a = (Asteroid)asteroids.get(i);
     for (int j = 0; j < bullets.size(); j++) {
       Bullet b = (Bullet)bullets.get(j);
       if (b.hit(a)) {
         if (a.getRadius() == 20) {
           int avx, avy, alx, aly;
           avx = a.getVX();
           avy = a.getVY();
           alx = a.getX();
           aly = a.getY();
           
           int detail1 = round(random(4,7));
           int detail2 = round(random(4,7));
           Asteroid a1 = new Asteroid (detail1, 10, 5, alx + 10 , aly + 5 , avx * -1 , avy );
           Asteroid a2 = new Asteroid (detail2, 10, 5, alx - 10 , aly - 5 , avx ,avy * -1 );
           
           asteroids.add(a1);
           asteroids.add(a2);
         }
         asteroids.remove(i);
         bullets.remove(j);
       }
     }
   }
 }
 
 class Asteroid{
 
   private int aX, 
     aY, 
     velX, 
     velY, 
     rotation, 
     clockwise, 
     detail, 
     radius;

   Asteroid(int d, int r, int id, int ix, int iy, int ivx, int ivy){
   this.detail = d;
   this.radius = r;
   this.rotation = 0;
   this.clockwise = floor (random(0,1));
   
   //pick side, send in random direction
   int initDirection = id;
   
   if (initDirection == 1){
     //top
      this.aY = 0;
      this.aX = round (random(0,width));
      this.rotation = round(random(91, 269));
      this.velX = round(random(-2,2));
      this.velY = round(random(1,2));
    }
   else if (initDirection == 2){
     //left
     this.aY = round (random(0,height));
     this.aX = 0;
     this.rotation = round(random(1, 179));
     this.velX = round(random(1,2));
     this.velY = round(random(-2,2));
   }
   else if (initDirection == 3){
     //right
     this.aY = round(random(0,height));
      this.aX = width;
      this.rotation = round(random(181, 359));
      this.velX = round(random(-2,-1));
      this.velY = round(random(-2,2));
   }
   else if (initDirection == 4){
     //bottom
     this.aY = height;
     this.aX = round(random(0,width));
     int opt = floor (random(0,1));
     if (opt==1){
       this.rotation = round(random(271, 359));
     }
     else{
       this.rotation = round(random(0, 89));
     }
     
     this.velX = round(random(-2,2));
     this.velY = round(random(-2,-1));
   }
   else if (initDirection== 5){
     this.aX = ix;
     this.aY = iy;
     int opt = floor (random(0,1));
     if (opt==1){
       this.rotation = round(random(271, 359));
     }
     else{
       this.rotation = round(random(0, 89));
     }
     this.velX = ivx;
     this.velY = ivy;
   }
 }//end of ctor
 
 void draw(){
   noStroke();
   this.update();
   pushMatrix();
   translate (this.aX,this.aY);
   rotate (radians(this.rotation));
   fill(105,105,105);
   sphereDetail(this.detail);
   sphere(radius);
   popMatrix();
 }
 
 void update(){
  this.aX += this.velX;
  this.aY += this.velY;
  if (this.clockwise == 1){
    if (this.rotation < 359){
      this.rotation += 1;
    }
    else{
      this.rotation = 0;
    }
  }
  else{
    if (this.rotation > 0){
      this.rotation -= 1;
    }
    else{
      this.rotation = 359;
    }
  }
  this.checkPos();
 }
 
 private void checkPos(){
   if(this.aX < 0){
     this.aX = width;
   }
   else if (this.aX > width){
     this.aX = 0;
   }
   else if (this.aY < 0){
     this.aY = height;
   }
   else if (this.aY > height){
     this.aY = 0;
   }
 }
 
 public int getX(){
   return this.aX;
 }
 
 public int getY(){
   return this.aY; 
 }
 
 private void setX(int nX) {
   this.aX = nX; 
 }
 
 private void setY(int nY) {
   this.aY = nY; 
 }
 
 public int getVX(){
   return this.velX;
 }

 public int getVY(){
   return this.velY;
 }
 
 public void setMovement(int newX, int newY){
  if ( newX > 2 || newX < -2) {
    if ( newX > 2) {
      this.velX = 2;
    }else{
      this.velX = -2;
    }
  }else{
    this.velX = newX;
  }
  if (newY > 2 || newY < -2) {
    if (newY > 2){
      this.velY = 2; 
    }else{
      this.velY = -2;
    }
  }else {
    this.velY = newY;
  } 
 }
 
 public int getRadius(){
   return this.radius; 
 }
 
 public void collided (Asteroid a) {
   PVector self = new PVector (this.aX,this.aY,0);
   PVector target = new PVector (a.getX(), a.getY(),0);
   
   PVector r = PVector.sub(self,target);

   if (r.mag() < (this.radius + a.getRadius())+ 2){
     this.handleCollision(a);
   }
 }
 
 private void handleCollision(Asteroid a){
   int taY,tlX,tlY;
   tlX = a.getX();
   tlY = a.getY();
   
   if (this.aX > tlX) {
     this.aX += 1;
     a.setX(tlX -1);
   } else {
     this.aX -= 1;
     a.setX(tlX + 1);
   }
   
   if (this.aY > tlY) {
     this.aY += 1;
     a.setY(tlY - 1);
   } else {
     this.aY -= 1;
     a.setY(tlY + 1);
   }
   
   if( (this.velX >= 0 && this.velY >= 0) && (a.getVX() >= 0 && a.getVY() >= 0)){ // ++,++
     taY = a.getVY();
     if (this.velX < taY) { 
       this.setMovement(a.getVX() - 1, this.velY + 1);
       a.setMovement(a.getVX() + 1, taY - 1);  
     } else {
       this.setMovement(a.getVX() + 1, this.velY - 1);
       a.setMovement(a.getVX() - 1, taY + 1);
     }
   } else if( (this.velX >= 0 && this.velY >= 0) && (a.getVX() >= 0 && a.getVY() <= 0)){ 
     this.setMovement(this.velX, (this.velY * -1));
     a.setMovement(a.getVX(), (a.getVY() * -1));
   } else if( (this.velX >= 0 && this.velY >= 0) && (a.getVX() <= 0 && a.getVY() >= 0)){
     this.setMovement((this.velX * -1), this.velY);
     a.setMovement((a.getVX() * -1),a.getVY());
   } else if( (this.velX >= 0 && this.velY >= 0) && (a.getVX() <= 0 && a.getVY() <= 0)){
     this.setMovement((this.velX * -1), (this.velY * -1));
     a.setMovement((a.getVX() * -1),(a.getVY() * -1));
   } else if( (this.velX >= 0 && this.velY <= 0) && (a.getVX() >= 0 && a.getVY() >= 0)){
     this.setMovement(this.velX, this.velY * -1);
     a.setMovement(a.getVX(), (a.getVY() * -1));
   } else if( (this.velX >= 0 && this.velY <= 0) && (a.getVX() >= 0 && a.getVY() <= 0)){// +-,+-
     taY = a.getVY();
     if (this.velX < taY) { 
       this.setMovement(a.getVX() - 1, this.velY + 1);
       a.setMovement(a.getVX() + 1, taY - 1);  
     } else {
       this.setMovement(a.getVX() + 1, this.velY - 1);
       a.setMovement(a.getVX() - 1, taY + 1);
     }   
   } else if( (this.velX >= 0 && this.velY <= 0) && (a.getVX() <= 0 && a.getVY() >= 0)){
     this.setMovement((this.velX * -1), this.velY * -1);
     a.setMovement((a.getVX() * -1),a.getVY() * -1);
   } else if( (this.velX >= 0 && this.velY <= 0) && (a.getVX() <= 0 && a.getVY() <= 0)){
     this.setMovement((this.velX * -1), this.velY);
     a.setMovement((a.getVX() * -1),a.getVY());
   } else if( (this.velX <= 0 && this.velY >= 0) && (a.getVX() >= 0 && a.getVY() >= 0)){
     this.setMovement((this.velX * -1), this.velY);
     a.setMovement((a.getVX() * -1), a.getVY());
   } else if( (this.velX <= 0 && this.velY >= 0) && (a.getVX() >= 0 && a.getVY() <= 0)){
     this.setMovement((this.velX * -1), (this.velY * -1));
     a.setMovement((a.getVX() * -1),(a.getVY() * -1));
   } else if( (this.velX <= 0 && this.velY >= 0) && (a.getVX() <= 0 && a.getVY() >= 0)){//-+,-+
     taY = a.getVY();
     if (this.velX < taY) { 
       this.setMovement(a.getVX() - 1, this.velY + 1);
       a.setMovement(a.getVX() + 1, taY - 1);  
     } else {
       this.setMovement(a.getVX() + 1, this.velY - 1);
       a.setMovement(a.getVX() - 1, taY + 1);
     }   
   } else if( (this.velX <= 0 && this.velY >= 0) && (a.getVX() <= 0 && a.getVY() <= 0)){
     this.setMovement(this.velX, this.velY * -1);
     a.setMovement(a.getVX(), (a.getVY() * -1));
   } else if( (this.velX <= 0 && this.velY <= 0) && (a.getVX() >= 0 && a.getVY() >= 0)){
     this.setMovement((this.velX * -1), (this.velY * -1));
     a.setMovement((a.getVX() * -1),(a.getVY() * -1));
   } else if( (this.velX <= 0 && this.velY <= 0) && (a.getVX() >= 0 && a.getVY() <= 0)){
     this.setMovement((this.velX * -1), this.velY);
     a.setMovement((a.getVX() * -1), a.getVY());
   } else if( (this.velX <= 0 && this.velY <= 0) && (a.getVX() <= 0 && a.getVY() >= 0)){
     this.setMovement(this.velX, this.velY * -1);
     a.setMovement(a.getVX(), (a.getVY() * -1));
   } else if( (this.velX <= 0 && this.velY <= 0) && (a.getVX() <= 0 && a.getVY() <= 0)){ //--,--
     taY = a.getVY();
     if (this.velX < taY) { 
       this.setMovement(a.getVX() - 1, this.velY + 1);
       a.setMovement(a.getVX() + 1, taY - 1);  
     } else {
       this.setMovement(a.getVX() + 1, this.velY - 1);
       a.setMovement(a.getVX() - 1, taY + 1);
     }  
   } 
 }
 
}

class Bullet{
 private PVector coords;
 private float velX, velY;
 private int bulletSize;
 
 Bullet(int direction, float startX, float startY){
   bulletSize = 4;
   coords = new PVector (startX, startY, 0);
   velX = sin(radians(direction))*7;
   velY = cos(radians(direction))*7;
 }
 
 public void draw(){
   this.update();
   ellipse(this.coords.x,this.coords.y, bulletSize, bulletSize);
 }
 
 public boolean isOffscreen (){
   if (this.coords.x < 0){
     return true;
   }
   else if (this.coords.x > width){
     return true;
   }
   else if (this.coords.y < 0){   
     return true;
   }
   else if (this.coords.y > height){
     return true;
   }
   else{
     return false;
   }
 }
 public void update(){
   this.coords.x += velX;
   this.coords.y -= velY;
 }
 public boolean hit (Asteroid a){
   PVector target = new PVector (a.getX(), a.getY(),0);
   
   PVector r = PVector.sub(coords,target);

   if (r.mag() < (this.bulletSize + a.getRadius())+ 2){
     return true;
   }
   return false;
 }  
}

class Player {
 private PVector xyTop, xyBottomLeft, xyBottomRight, xyPosition;
 private float velX, velY;
 private int rotation, thrust, maxThrust;
 private float friction, deltaTimer, gravTime;
 
 Player() {
   /*center of mass of the player*/
   xyPosition = new PVector (width / 2, height / 2, 0);
   
   /*draw positions of the player (relative to xyPosition)*/
   xyTop = new PVector (0, -14, 0);
   xyBottomLeft = new PVector (xyTop.x - 7, xyTop.y + 21, 0);
   xyBottomRight = new PVector (xyTop.x + 7, xyTop.y + 21, 0);
   
   /*movement variables*/
   rotation = 0;
   thrust = 10;
   velX = velY = 0.0f;
   maxThrust = 50;
   friction = 0.999;
   deltaTimer = gravTime = 0.0f;
   
 }
   
 void draw() {
   update();
   pushMatrix();
   translate (xyPosition.x,xyPosition.y);
   rotate (radians(rotation));
   fill(255,0,0);
   triangle (xyTop.x,xyTop.y,xyBottomLeft.x,xyBottomLeft.y,xyBottomRight.x,xyBottomRight.y);
   popMatrix();
 }
 
 void update() {
   gravTime += getDelta();
   if (gravTime > 50.0f){
     velX *= friction;
     velY *= friction; 
     gravTime = 0.0f;
   }
   
   xyPosition.x += velX/10;
   xyPosition.y += velY/10;
   if (xyPosition.x < 0){
     xyPosition.x = width;
   }
   else if (xyPosition.x > width){
     xyPosition.x = 0;
   }
   
   if (xyPosition.y < 0){   
     xyPosition.y = height;
   }
   else if (xyPosition.y > height){
     xyPosition.y = 0;
   }
 }
 
 void accelerate() {
   
   velX += sin(radians(rotation)) * thrust;
   velY -= cos(radians(rotation)) * thrust;
   
   if (velX > maxThrust){
     velX = maxThrust;
   }
   else if (velX < -maxThrust){
    velX = -maxThrust; 
   }
   
   if (velY > maxThrust){
     velY = maxThrust; 
   }
   else if(velY < -maxThrust){
     velY = -maxThrust;
   }
 }
 
 void turn(int key) {
   if (key == 37){
     if (rotation == 0){
       rotation = 359;
     }
     else{
       rotation -= 12;
     }
   }
   else if (key == 39) {
     if (rotation == 359){
       rotation = 0;
     }
     else{
       rotation += 12; 
     }
   }
 }
 
 void shoot() {
   if (bullets.size() < 6){
     Bullet b = new Bullet(rotation, xyPosition.x, xyPosition.y);
     bullets.add((Bullet)b); 
   }
 }
 
 private float getDelta() {
  float millisElapsed = millis() - deltaTimer;
  deltaTimer = millis();
  return millisElapsed;
 }
 
 PVector getxyPosition() {
   return this.xyPosition;
 }
 
 PVector getxyTop() {
   return this.xyTop;
 }
 
 PVector getxyBottomLeft() {
   return this.xyBottomRight;
 }
 
 PVector getxyBottomRight() {
   return this.xyBottomRight; 
 }
}
