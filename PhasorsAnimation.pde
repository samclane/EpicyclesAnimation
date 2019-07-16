int RADIUS = 50;
float FREQ = 0.02;
int NUM_TERMS = 50;

Phasor[] function;
PVector[] points = new PVector[round(TWO_PI/FREQ)];

HScrollbar hRadius, hFreq, hTerms;

PVector[] shiftRight(PVector[] arr) {
  PVector last =  arr[arr.length-1];
  for(int index=arr.length-2; index >= 0; index--) {
    arr[index+1] = arr[index];
  }
  arr[0] = last;
  return arr;
}

Phasor[] squareWave(int numTerms) {
  Phasor[] function = new Phasor[numTerms];
  for (int i = 0; i < numTerms; i++) {
    int term = 2 * i + 1;
    function[i] = new Phasor((4*RADIUS)/(PI*term), term*FREQ);
  }
  return function;
}

Phasor[] sawWave(int numTerms) {
  Phasor[] function = new Phasor[numTerms];
  for (int  i = 1; i <= numTerms; i++) {
    function[i-1] = new Phasor((2*RADIUS)/(PI*i), i*FREQ);
  }
  return function;
}

Phasor[] triangleWave(int numTerms) {
  Phasor[] function = new Phasor[numTerms];
  for (int i = 0; i < numTerms; i++) {
    int n = (2 * i) + 1;
    function[i] = new Phasor(RADIUS*pow(-1, i)*(PI/4)*pow(n, -2), n*FREQ);
  }
  return function;
}

PVector drawEpicycles() {
  PVector pen = new PVector(0, 0);
  for (Phasor p : function) {
    PVector tip = new PVector(p.amplitude*cos(p.phase), p.amplitude*sin(p.phase));
    circle(0, 0, p.amplitude*2);
    line(0, 0, tip.x, tip.y);
    p.update();
    translate(p.amplitude*cos(p.phase), p.amplitude*sin(p.phase));
    pen.add(tip);
  }
  return pen;
}

void setup() {
  size(900, 700);
  frameRate(60);
  for (int i = 0; i < points.length; i++) {
    points[i] = new PVector(0, 0);
  }
  //function = squareWave(NUM_TERMS);
  function = sawWave(NUM_TERMS);
  //function = triangleWave(NUM_TERMS);
  
  hRadius = new HScrollbar(0, 7*height/8 + 8 + 0, width, 16, 16);
  hFreq = new HScrollbar(0, 7*height/8 + 24 + 8, width, 16, 16);
  hTerms = new HScrollbar(0, 7*height/8 + 40 + 16, width, 16, 16);
}

int counter = 0;
void draw() {
  // initialize
  background(0);
  stroke(255);
  noFill();
  // Get slider settings
  //RADIUS = round(hRadius.getPos());
  //FREQ = round(hFreq.getPos());
  //NUM_TERMS = round(hTerms.getPos());
  // draw epicycles
  pushMatrix();
  translate(width/4, height/5); // left side

  pushMatrix();
  pushStyle();
  stroke(127);
  PVector pen_tip = drawEpicycles();

  // save drawing vertices
  shiftRight(points);
  points[0] = pen_tip;

  popStyle();
  popMatrix();

  // draw pen_tip vertices
  pushStyle();
  stroke(255, 0, 0);
  beginShape();
  for (PVector pv : points) {
    vertex(pv.x, pv.y);
  }
  endShape();

  popStyle();
  line(pen_tip.x, pen_tip.y, width/4, pen_tip.y);
  line(pen_tip.x, pen_tip.y, pen_tip.x, height/7.5);
  popMatrix();

  // Draw Y waveform
  pushMatrix();
  translate(width/2, height/5);
  beginShape();
  
  for (int i = 0; i < points.length; i++) {
    vertex(i, points[i].y);
  }
  
  endShape();
  popMatrix();
  
  // Draw X Waveform
  pushMatrix();
  translate(width/4, height/3);
  beginShape();
  for (int i = 0; i < points.length; i++) {
    vertex(points[i].x, i); 
  }
  endShape();
  popMatrix();
  resetMatrix();
  hRadius.update();
  hFreq.update();
  hTerms.update();
  /*
  hRadius.display();
  hFreq.display();
  hTerms.display();
  */
  if (counter < round(TWO_PI/FREQ)) {
    // ffmpeg -framerate 60 -i "%06d.tif" -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
    // ffmpeg -framerate 60 -i "%06d.tif" -r 30 out.gif
    saveFrame("output/######.tif");
    counter++;
  }
  else {
    exit();
  }
}

class Phasor {
  float amplitude;
  float frequency;
  float phase;

  Phasor (float a, float f, float p) {
    amplitude = a;
    frequency = f;
    phase = p;
  }

  Phasor(float a, float f) {
    amplitude = a;
    frequency = f;
    phase = 0;
  }

  Phasor() {
    amplitude = 0;
    frequency = 0;
    phase = 0;
  }

  void update() {
    phase += frequency;
    phase %= TWO_PI;
  }
}
