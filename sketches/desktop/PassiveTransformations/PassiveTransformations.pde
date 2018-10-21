import frames.core.*;
import frames.primitives.*;
import frames.processing.*;

Graph graph;
Frame[] frames;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  graph = new Graph(width, height);
  GLSLMatrixHandler glslMatrixHandler = new GLSLMatrixHandler(graph);
  graph.setMatrixHandler(glslMatrixHandler);
  graph.setFieldOfView(PI / 3);
  graph.fitBallInterpolation();
  frames = new Frame[50];
  for (int i = 0; i < frames.length; i++) {
    frames[i] = new Frame(graph) {
      @Override
      public void visit() {
        pushStyle();
        fill(isTracked(graph) ? 0 : 255, 0, 255);
        box(5);
        popStyle();
      }
    };
    frames[i].randomize();
  }
  //discard Processing matrices
  resetMatrix();
}

void draw() {
  background(0);
  graph.preDraw();
  graph.traverse();
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

public class GLSLMatrixHandler extends MatrixHandler {
  PShader framesShader;
  PMatrix3D pmatrix = new PMatrix3D();

  public GLSLMatrixHandler(Graph graph) {
    super(graph);
    framesShader = loadShader("frame_frag.glsl", "frame_vert_pmv.glsl");
  }

  @Override
  protected void _setUniforms() {
    shader(framesShader);
    // same as:
    //pmatrix.set(Scene.toPMatrix(projectionModelView()));
    //pmatrix.transpose();
    pmatrix.set(projectionModelView().get(new float[16]));
    framesShader.set("frames_transform", pmatrix);
  }
}
