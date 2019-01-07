class TimeoutButton {

  int x;
  int y;
  int w;
  int h;
  float timeout;

  boolean inside;
  int startFrame;
  int showPress = 0;
  float secInside = -1;

  TimeoutButton(int x, int y, int w, int h, float timeout) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.timeout = timeout;
  }

  void render() {

    // white after pressed
    if (showPress > 0) {
      fill(255);
      showPress--;
    } else {
      fill(100);
    }
    noStroke();
    rect(x, y, w, h);

    // show progress in red
    if (secInside > 0 && showPress <= 0) {
      fill(255, 0, 0);
      rect(x, y, secInside/timeout * w, h);
    }

    fill(255);
    textAlign(CENTER);
    //textSize(30);
    text(""+timeout, x + w/2, y + h/2 + 15);
  }

  boolean oneIsIn(ArrayList<PVector> points) {
    for (PVector v : points) {
      if (v.x >= x && v.x <= x + w && v.y >= y && v.y <= y + h) {
        return true;
      }
    }
    return false;
  }

  void update(ArrayList<PVector> cursors) {
    if (oneIsIn(cursors)) {
      if (inside) {
        secInside = (float(frameCount - startFrame)) / frameRate;
        if (secInside > timeout) {
          startFrame = frameCount;
          pressed();
        }
      } else {
        inside = true;
        startFrame = frameCount;
      }
    } else {
      inside = false;
      secInside = -1;
    }
  }

  void pressed() {
    showPress = 10;
    secInside = -1;
  }
}
