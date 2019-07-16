import java.util.*;
import java.util.Set;
import java.util.HashSet;

final int RADIUS = 50;
final float FREQ = 0.01;
final int NUM_TERMS = 50;

Phasor[] function;

// PVector[] points = new PVector[513];
Set<PVector> points;

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
  frameRate(144);
  for (int i = 0; i < points.size(); i++) {
    points.add(new PVector(0, 0));
  }
  function = squareWave(NUM_TERMS);
  //function = sawWave(NUM_TERMS);
  //function = triangleWave(NUM_TERMS);
}

void draw() {
  // initialize
  background(0);
  stroke(255);
  noFill();
  // draw epicycles
  pushMatrix();
  translate(width/4, height/5); // left side

  pushMatrix();
  pushStyle();
  stroke(127);
  PVector pen_tip = drawEpicycles();

  // save drawing vertices
  points.add(pen_tip);

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
  
  PVector[] pArray = (PVector[])points.toArray();
  for (int i = 0; i < points.size(); i++) {
    vertex(i, points.get(i).y);
  }
  endShape();
  popMatrix();
  
  // Draw X Waveform
  pushMatrix();
  translate(width/4, height/3);
  beginShape();
  for (int i = 0; i < points.size(); i++) {
    vertex(points.get(i).x, i); 
  }
  endShape();
  popMatrix();
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
