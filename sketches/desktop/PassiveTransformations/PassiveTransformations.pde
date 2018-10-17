import frames.core.*;
import frames.primitives.*;

Graph graph;
PShader framesShader;
Matrix pmv;
PMatrix3D pmatrix = new PMatrix3D();
Frame[] frames;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  graph = new Graph(width, height);
  graph.setFieldOfView(PI / 3);
  graph.fitBallInterpolation();
  framesShader = loadShader("frame_frag.glsl", "frame_vert_pmv.glsl");
  frames = new Frame[50];
  for (int i = 0; i < frames.length; i++)
    frames[i] = Frame.random(new Vector(), 100, g.is3D());
}

void draw() {
  graph.preDraw();
  background(0);
  //discard Processing matrices
  resetMatrix();
  //set initial model-view and projection matrices
  setUniforms();
  for (int i = 0; i < frames.length; i++) {
    graph.pushModelView();
    graph.applyModelView(frames[i].matrix());
    //model-view changed:
    setUniforms();
    fill(0, frames[i].isTracked(graph) ? 0 : 255, 255);
    box(5);
    graph.popModelView();
  }
}

void mouseMoved() {
  graph.track(mouseX, mouseY, frames);
}

void mouseDragged() {
  if (mouseButton == LEFT)
    graph.spin(new Point(pmouseX, pmouseY), new Point(mouseX, mouseY));
  else if (mouseButton == RIGHT)
    graph.translate(mouseX - pmouseX, mouseY - pmouseY);
  else
    graph.scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) {
  graph.scale(event.getCount() * 20);
}

//Whenever the model-view (or projection) matrices changes
// we need to update the shader:
void setUniforms() {
  shader(framesShader);
  pmv = Matrix.multiply(graph.projection(), graph.modelView());
  pmatrix.set(pmv.get(new float[16]));
  framesShader.set("frames_transform", pmatrix);
}
