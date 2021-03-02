import java.util.*;
Random rand = new Random(0);

final int PERMUTATIONS = 256;
final int PMASK = PERMUTATIONS-1;
int[] permutationArray;

final int SCALE_FACTOR = 2;
final int OCTAVES = 8;

void setup() {
  size(400, 400);
  smooth(0);
  
  permutationArray = new int[PERMUTATIONS*2];
  for (int i = 0; i < PERMUTATIONS; i++) {
    permutationArray[i] = i;
  }
  shuffle(permutationArray);
  for (int i = PERMUTATIONS; i < PERMUTATIONS*2; i++) {
    permutationArray[i] = permutationArray[i - PERMUTATIONS];
  }
}

void draw() {
  background(0);
  strokeWeight(1);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      PVector v = new PVector(x, y);
      v = pixToWorld(v);
      v.mult(SCALE_FACTOR);
      int sum = 0;
      for (int octave = 0; octave < OCTAVES; octave++) {
        sum += colorFloatToInt(perlin(v.x, v.y, 0)) / (1 << (octave + 1));
        v.mult(2);
      }
      stroke(sum);
      point(x, y);
    }
  }
  //shuffle(permutationArray);
  for (int i = 0; i < 1; i++) {
    swap(permutationArray, rand.nextInt(PERMUTATIONS), rand.nextInt(PERMUTATIONS));
  }
  
  strokeWeight(1);
  for (int x = -SCALE_FACTOR; x <= SCALE_FACTOR; x++) {
    for (int y = -SCALE_FACTOR; y <= SCALE_FACTOR; y++) {
      int sectionX, sectionY;
      sectionX = floor(x) & PMASK;
      sectionY = floor(y) & PMASK;
      
      int[] p = permutationArray;
      int permCornerTopLeft  = p[(p[(sectionX)]+sectionY)];
      PVector cornerTopLeft  = getConstantVec(permCornerTopLeft);
      
      cornerTopLeft.mult(25);
      
      stroke(232);
      PVector pt = worldToPix(new PVector(x, y).div(SCALE_FACTOR));
      //strokeWeight(10);
      //point(p.x, p.y);
      //line(pt.x, pt.y, pt.x + cornerTopLeft.x, pt.y + cornerTopLeft.y);
    }
  }
  
  PVector mouse = pixToWorld(new PVector(mouseX, mouseY)).mult(SCALE_FACTOR);
  System.out.printf("mouse %6.3f %6.3f\n", mouse.x, mouse.y);
  
  strokeWeight(11);
  stroke(255);
  //point(mouseX, mouseY);
  strokeWeight(10);
  stroke(colorFloatToInt(perlin(mouse.x, mouse.y, 0)));
  //point(mouseX, mouseY);
}

float perlin(float x, float y, float z) {
  int sectionX, sectionY;
  float offsetX, offsetY;
  sectionX = floor(x) & PMASK;
  sectionY = floor(y) & PMASK;
  offsetX = x-floor(x);
  offsetY = y-floor(y);
  
  PVector pointTopLeft  = new PVector(offsetX,     offsetY);
  PVector pointTopRight = new PVector(offsetX - 1, offsetY);
  PVector pointBotLeft  = new PVector(offsetX,     offsetY - 1);
  PVector pointBotRight = new PVector(offsetX - 1, offsetY - 1);
  
  int[] p = permutationArray;
  int permCornerTopLeft  = p[(p[(sectionX  )]+sectionY  )];
  int permCornerTopRight = p[(p[(sectionX+1)]+sectionY  )];
  int permCornerBotLeft  = p[(p[(sectionX  )]+sectionY+1)];
  int permCornerBotRight = p[(p[(sectionX+1)]+sectionY+1)];
  
  PVector cornerTopLeft  = getConstantVec(permCornerTopLeft);
  PVector cornerTopRight = getConstantVec(permCornerTopRight);
  PVector cornerBotLeft  = getConstantVec(permCornerBotLeft);
  PVector cornerBotRight = getConstantVec(permCornerBotRight);
  
  float dotTopLeft  = pointTopLeft .dot(cornerTopLeft);
  float dotTopRight = pointTopRight.dot(cornerTopRight);
  float dotBotLeft  = pointBotLeft .dot(cornerBotLeft);
  float dotBotRight = pointBotRight.dot(cornerBotRight);
  
  float u = fade(offsetX);
  float v = fade(offsetY);
  return mlerp(v, mlerp(u, dotTopLeft, dotTopRight), mlerp(u, dotBotLeft, dotBotRight)) / 2 + .5;
}

PVector getConstantVec(int permutation) {
  switch (permutation & 7) {
    case 0:
      return new PVector( 1,  1,  1);
    case 1:
      return new PVector( 1,  1, -1);
    case 2:
      return new PVector( 1, -1,  1);
    case 3:
      return new PVector( 1, -1, -1);
    case 4:
      return new PVector(-1,  1,  1);
    case 5:
      return new PVector(-1,  1, -1);
    case 6:
      return new PVector(-1, -1,  1);
    case 7:
      return new PVector(-1, -1, -1);
  }
  return null;
}

int[] shuffle(int array[]) {
  for (int i = 0; i < PERMUTATIONS; i++) {
    swap(array, i, rand.nextInt(PERMUTATIONS - i) + i);
  }
  return array;
}

void swap(int array[], int idxA, int idxB) {
  int temp = array[idxA];
  array[idxA] = array[idxB];
  array[idxB] = temp;
}
