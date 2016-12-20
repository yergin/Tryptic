class MyOPC extends OPC {
  MyOPC(String host, int port, int wid, int hgt) {
    super(host, port, wid, hgt);
  }

  void ledLine(int index, int count, float x1, float y1, float x2, float y2, int group)
  {
    float xDelta = (x2 - x1) / (count - 1);
    float yDelta = (y2 - y1) / (count - 1);
    for (int i = 0; i < count; i++) {
      led(index + i, (int)(x1 + i * xDelta + 0.5), (int)(y1 + i * yDelta + 0.5), group);
    }
  }
  
  void ledTriangle(int index, int sideLength, PVector v1, PVector v2, PVector v3, int group) {
    PVector delta12 = PVector.div(PVector.sub(v2, v1), sideLength - 1);
    PVector delta23 = PVector.div(PVector.sub(v3, v2), sideLength - 1);
    for (int i12 = 0; i12 < sideLength; ++i12) {
      PVector v12 = PVector.add(v1, PVector.mult(delta12, i12));
      for (int i23 = 0; i23 <= i12; ++i23) {
        int i = (i12 % 2 == 1) ? i23 : i12 - i23;
        PVector v = PVector.add(v12, PVector.mult(delta23, i));
        led(index++, (int)(v.x + 0.5), (int)(v.y + 0.5), group);
      }
    }
  }
};