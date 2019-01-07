// import com.onformative.leap.LeapMotionP5;
import de.voidplus.leapmotion.*;
import controlP5.*;
import de.looksgood.ani.*;



float INTERACTION_SPACE_WIDTH = 200; //150;
float INTERACTION_SPACE_DEPTH = 120; //120;
float FINGER_DOT= 20;

ControlP5 p5;
LeapMotion leap;
ArrayList<TimeoutButton> buttons = new ArrayList<TimeoutButton>();
ArrayList<PVector> cursors = new ArrayList<PVector>();

ArrayList<MenuPanel> menuPanels = new ArrayList<MenuPanel>();

PVector gesturePosition;
PVector refreshBtnPosition;
PVector refreshBtnDimension;


PVector rectPos;
int elementDist;


boolean showMenues = true;

int yellow =  color(198, 200, 12);
int blue =  color(12, 80, 120);

PImage cookIco;
PImage clockIco;
PImage hookIco_s;

String [] names = {"Diana Schneider", "Paul Hölzer"};
String [] menues = {"Zwei hausgemachte Fleischköchle", "Käsespätzle mit Rahmsoße", "Käsespätzle mit Rindfleisch", "Maultaschen mit Soße"};


void setup(){
  size(414, 736);
  p5 = new ControlP5(this);
  leap = new LeapMotion(this).allowGestures("swipe, key_tap");

  rectPos = new PVector(76, 130);
  elementDist = 130;

  refreshBtnPosition = new PVector(322, 13);
  refreshBtnDimension = new PVector(70, 58);

  for(int i = 0; i < 4; i++){
    menuPanels.add(new MenuPanel(menues[i], rectPos.x, rectPos.y + i*elementDist, blue));
  }

  for (MenuPanel m : menuPanels){
    println("id: "+ m.getID());
  }
  buttons.add(new TimeoutButton(19, 684, 42, 42, .5));

  p5.addButton("refreshBtn")
     .setPosition(refreshBtnPosition.x, refreshBtnPosition.y)
     .setImages(loadImage("refresh_black.png"), loadImage("refresh_grey.png"), loadImage("refresh_grey.png"))
     .updateSize();

  p5.addButton("purchaseOrderBtn")
     .setPosition(19, 684)
     .setImage(loadImage("purchase-order.png"))
     .updateSize();

  p5.addButton("hook_lBtn")
     .setPosition(349, 681)
     .setImage(loadImage("hook-l_black.png"))
     .updateSize();

  Ani.init(this);

}

void draw(){
  background(0);
  cursors.clear();

  // top rectangle
  stroke(0);
  fill(blue);
  rect(0, 0, 414, 108);
  //bottom rect
  rect(0, 673, 414, 64);

  // name
  fill(0);
  text(names[0], 14, 35);

  for (Hand hand : leap.getHands()){
    Finger index = hand.getIndexFinger();
    PVector pos = index.getPosition();
    cursors.add(pos);
  }

  for (TimeoutButton b : buttons){
    b.update(cursors);
  }

  if (showMenues){
    for (MenuPanel menu : menuPanels){
      menu.render();
    }
  }
  // draw index finger
  for (Hand hand : leap.getHands()){
    PVector finger = hand.getThumb().getRawPositionOfJointTip();
    handleFinger(finger, "thb");

     finger = hand.getIndexFinger().getRawPositionOfJointTip();
    handleFinger(finger, "idx");

     finger = hand.getMiddleFinger().getRawPositionOfJointTip();
    handleFinger(finger, "mfg");

     finger = hand.getRingFinger().getRawPositionOfJointTip();
    handleFinger(finger, "rfg");

     finger = hand.getPinkyFinger().getRawPositionOfJointTip();
    handleFinger(finger, "pfg");

  }

} // end of draw

public void refreshPanels(){
    for(MenuPanel menu : menuPanels){
     menu.setVisible(true);
  }
}

public void controlEvent(ControlEvent theEvent){
  println(theEvent.getController().getName());

}

public void refreshBtn(int theValue){
  println("button event from refreshButton: "+theValue);
      for(MenuPanel m : menuPanels){
     m.setVisible(true);
  }
}

void handleFinger(PVector pos, String id){
  float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
  float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);

  // println("finger y: "+y);

  fill(#00e310);
  noStroke();
  ellipse(x,y,FINGER_DOT, FINGER_DOT);
  fill(#000000);
  text(id, x, y);
}

void handleSwipe(float x, float y){
  println("x: " + x + ", y: "+y);
  for (MenuPanel menu : menuPanels){
    PVector[] dimensions = menu.getPanelDimension();

    if(dimensions[0].x < x && x < dimensions[1].x &&
      dimensions[0].y < y && y < dimensions[1].y ){
      menu.setVisible(false);
      int id = menu.getID();
      println("deactivated panel no "+ id);

      for (MenuPanel m : menuPanels){
        if (id >= m.getID()){
          m.movePanel();
        }
      }
    }
  }
}

void leapOnSwipeGesture(SwipeGesture g, int state){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getRawPosition();
  PVector positionStart    = g.getRawStartPosition();
  PVector direction        = g.getDirection();
  float   speed            = g.getSpeed();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  float x = map(positionStart.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
  float y = map(positionStart.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
      println("SwipeGesture: " + id  + ", Finger id: "+ finger.getId());
      handleSwipe(x, y);
      break;
  }
}

void handleTap(float x, float y){
  if (x > refreshBtnPosition.x && x < (refreshBtnPosition.x + refreshBtnDimension.x) &&
      y > refreshBtnPosition.y && y < (refreshBtnPosition.y + refreshBtnDimension.y)){
        println("tipped on refreshBtn");
        refreshPanels();
      }
}
// ======================================================
// 4. Key Tap Gesture

void leapOnKeyTapGesture(KeyTapGesture g){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector positionRaw      = g.getRawPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  float x = map(positionRaw.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
  float y = map(positionRaw.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);

  println("KeyTapGesture: " + id+ ", x: " + x + ", y: " + y);
  handleTap(x, y);
}
