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
