import java.util.concurrent.atomic.AtomicInteger;


class MenuPanel{
  final AtomicInteger idGenerator = new AtomicInteger(0);

 int id;
 private PVector pos;
 private PVector dimension;
 private int distance;

 String name;

 PVector textPos;
 PVector cookIcoPos;
 PVector clockIcoPos;
 PVector hookIcoPos;

 PImage cookIcoBlack;
 PImage cookIcoGrey;
 PImage clockIcoBlack;
 PImage clockIcoGrey;
 PImage hookIcoBlack;
 PImage hookIcoGrey;

 int col;

 boolean visible;
 boolean move;

 MenuPanel(String name, int posX, int posY, int col) {

     this.name = name;
     this.pos = new PVector(posX, posY);
     this.dimension = new PVector(334, 115);
     this.distance = 130;
     this.col = col;


     this.textPos = new PVector(this.pos.x + 10, this.pos.y + 15);
     this.cookIcoPos = new PVector(this.pos.x + 10, this.pos.y + 50);
     this.clockIcoPos = new PVector(this.pos.x + 102, this.pos.y + 50);
     this.hookIcoPos = new PVector(this.pos.x + 177, this.pos.y + 55);

     cookIcoBlack = loadImage("kochmütze-png.png");
     cookIcoGrey = loadImage("kochmütze_grey.png");
     clockIcoBlack = loadImage("clock_black.png");
     clockIcoBlack = loadImage("clock_grey.png");
     hookIcoBlack = loadImage("hook-s_black.png");
     hookIcoGrey = loadImage("hook-s_grey.png");

     this.id = idGenerator.getAndIncrement();
     println("panel id: "+ this.id);
     visible = true;
 }

 int getID(){
   return this.id;
 }

 void render(){
   if (visible){
     //draw rect
     fill(this.col);
     noStroke();
     rect(pos.x, pos.y, dimension.x, dimension.y);

     //draw text
     fill(0);
     text(this.name, this.textPos.x, this.textPos.y);

     //draw images
     image(cookIcoBlack, cookIcoPos.x, cookIcoPos.y);
     image(clockIcoBlack, clockIcoPos.x, clockIcoPos.y);
     image(hookIcoBlack, hookIcoPos.x, hookIcoPos.y);

   }
 }
 void setVisible(boolean vis){
   this.visible = vis;
 }

 PVector[] getPanelDimension(){
   PVector pos2 = new PVector(this.pos.x + this.dimension.x, this.pos.y + this.dimension.y);
   PVector[] ret = {this.pos, pos2};
   return ret;
 }

 void movePanel(){
   println("moving panel");
   Ani.to(this.pos, 1.0f, "y", (this.pos.y - distance));
   Ani.to(this.textPos, 1.0f, "y", (this.textPos.y - distance));
   Ani.to(this.cookIcoPos, 1.0f, "y", (this.cookIcoPos.y - distance));
   Ani.to(this.hookIcoPos, 1.0f, "y", (this.hookIcoPos.y - distance));
   Ani.to(this.clockIcoPos, 1.0f, "y", (this.clockIcoPos.y - distance));

 }
}
