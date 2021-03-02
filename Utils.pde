

float lerpTest(float x, float y) {
  return map(x, -1, 1, map(y, -1, 1, 0, 1), map(y, -1, 1, 1, 0));
}

PVector worldToPix(PVector v) {
  PVector o = new PVector();
  o.x = map(v.x, 0, 1, 0, width);
  o.y = map(v.y, 0, 1, height, 0);
  return o;
}

PVector pixToWorld(PVector v) {
  PVector o = new PVector();
  o.x = map(v.x, 0,  width, 0, 1);
  o.y = map(v.y, height, 0, 0, 1);
  return o;
}

int colorFloatToInt(float c) {
  return (int) (c * 255) & 255;
}

float mlerp(float t, float a, float b) {
  return a + t * (b-a);
}

float fade(float t){
  return ((6*t - 15)*t + 10)*t*t*t;
}
