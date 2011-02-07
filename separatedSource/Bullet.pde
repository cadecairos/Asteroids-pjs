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

