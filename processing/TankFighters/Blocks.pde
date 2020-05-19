class Block{
  float x, y, w, h, RED, GREEN, BLUE;
  PImage texture;
  int type;
  Block(float x, float y, float w, float h, PImage texture, int type){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.texture = texture;
    this.type = type;
  }
   
  Block(float x, float y, float w, float h, float RED, float GREEN, float BLUE, int type){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.texture = null;
    this.RED = RED;
    this.GREEN = GREEN;
    this.BLUE = BLUE;
    this.type = type;
  }
  
  void update(){
    Draw();
  }
  
  
  void isColliding(Tank tank){
    float offset = 2.5;
    if(tank.pos.x+tank.r/2-offset >= x*it && tank.pos.x-tank.r/2+offset <= (x+w)*it && tank.pos.y+tank.r/2-offset >= y*it && tank.pos.y-tank.r/2+offset <= (y+h)*it){
      tank.pos.add(tank.pos.copy().sub((x+w/2)*it, (y+h/2)*it).setMag(1)).sub(tank.vel);
      tank.vel.div(100);
      //tank.pos.sub(tank.vel);
      //tank.pos.sub(tank.acc);
      //tank.acc.set(0, 0);
    }

  }
  
  void Draw(){
    if(texture == null){
      fill(RED, GREEN, BLUE);
      rect(x*it, y*it, w*it, h*it);
    }
    else{
      image(texture, x*it + (w*it)/2, y*it + (h*it)/2);
    }
  }
}