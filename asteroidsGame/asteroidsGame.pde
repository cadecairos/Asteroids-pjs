import processing.opengl.*;

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
    if (create >= 698){
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
