import codeanticode.syphon.*;

MyOPC opc;
Preview preview;

int CAPTURE_WIDTH = 320;
int CAPTURE_HEIGHT = 240;
int TRIANGLE_FAN_OFFSET = 20;
float TRIANGLE_SIZE = 115;
float TRIANGLE_CENTER_OFFSET = 30;
int FRONT_GROUP = 0;
int BACK_GROUP = 1;
PGraphics pg;

SyphonClient frontSyphonClient;
SyphonClient backSyphonClient;
PImage frontCapture;
PImage backCapture;

void createTrypticLayout() {
  int[] fadeCandyOffsets = new int[4];
  fadeCandyOffsets[0] = 64 * 0;
  fadeCandyOffsets[1] = 64 * 2;
  fadeCandyOffsets[2] = 64 * 8;
  fadeCandyOffsets[3] = 64 * 10;  
  
  PVector center = new PVector(CAPTURE_WIDTH / 2, CAPTURE_HEIGHT / 2 + TRIANGLE_CENTER_OFFSET);
  PVector v1 = new PVector(0, -TRIANGLE_FAN_OFFSET);
  PVector v2 = new PVector(-TRIANGLE_SIZE / 2, -TRIANGLE_SIZE * cos(PI * 30 / 180) + v1.y);
  PVector v3 = new PVector(TRIANGLE_SIZE / 2, v2.y);
  
  v1.rotate(PI * -90 / 180);
  v2.rotate(PI * -90 / 180);
  v3.rotate(PI * -90 / 180);
  
  int index = 0;
  for (int i = 0; i < 4; ++i) {
    opc.ledTriangle(fadeCandyOffsets[i], 9, PVector.add(v1, center), PVector.add(v2, center), PVector.add(v3, center), FRONT_GROUP);
    opc.ledTriangle(fadeCandyOffsets[i] + 64, 9, PVector.add(v1, center), PVector.add(v3, center), PVector.add(v2, center), BACK_GROUP);

    v1.rotate(PI * 60 / 180);
    v2.rotate(PI * 60 / 180);
    v3.rotate(PI * 60 / 180);
    
    index = index + 128;
  }  
}

void settings() {
  size(320, 480, P2D);
  PJOGL.profile = 1;
}

void setup() {
  preview = new Preview();
  opc = new MyOPC("127.0.0.1", 7890, CAPTURE_WIDTH, CAPTURE_HEIGHT);
  frontSyphonClient = new SyphonClient(this, "TrypticTester", "Front");
  backSyphonClient = new SyphonClient(this, "TrypticTester", "Back");
  
  createTrypticLayout();
}

void captureSyphon() {
  if (frontSyphonClient.newFrame()) {
    frontCapture = frontSyphonClient.getImage(frontCapture);
  }
  if (backSyphonClient.newFrame()) {
    backCapture = backSyphonClient.getImage(backCapture);
  }
}

void draw() {
  background(0);
  captureSyphon();
  opc.capture(frontCapture, FRONT_GROUP);
  opc.capture(backCapture, BACK_GROUP);
  opc.writePixels();
  scale(1.0, -1.0);
  if (frontCapture != null)
    image(frontCapture, 0, 0, CAPTURE_WIDTH, -CAPTURE_HEIGHT);
  if (backCapture != null)
    image(backCapture, 0, -CAPTURE_HEIGHT, CAPTURE_WIDTH, -CAPTURE_HEIGHT);
}

class Preview extends PApplet {
  //JFrame frame;

  public Preview() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(640, 480, P3D);
    smooth();
  }
  
  public void setup() {
  }

  public void draw() {
    background(0);
    noStroke();
    for (int i = 0; i < opc.pixelLocations.length; ++i) {
      int x = opc.pixelLocations[i] % CAPTURE_WIDTH * 2;
      int y = opc.pixelLocations[i] / CAPTURE_WIDTH * 2;
      if (opc.pixelGroups[i] == BACK_GROUP) {
        x = (int)(0.95 * (x - CAPTURE_WIDTH)) + CAPTURE_WIDTH;
        y = (int)(0.95 * (y - CAPTURE_HEIGHT)) + CAPTURE_HEIGHT;
      }
      fill(opc.getPixel(i));
      ellipse(x, y, 6, 6);
    }
  }
}