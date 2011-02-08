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

