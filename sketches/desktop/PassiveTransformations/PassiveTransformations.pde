import nub.core.*;
import nub.primitives.*;
import nub.processing.*;

Graph graph;
Node[] nodes;

void settings() {
  size(800, 800, P3D);
}

void setup() {
  graph = new Graph(width, height);
  GLSLMatrixHandler glslMatrixHandler = new GLSLMatrixHandler(graph);
  graph.setMatrixHandler(glslMatrixHandler);
  graph.setFOV(PI / 3);
  graph.fit(1);
  nodes = new Node[50];
  for (int i = 0; i < nodes.length; i++) {
    nodes[i] = new Node(graph) {
      @Override
      public void visit() {
        pushStyle();
        fill(isTracked(graph) ? 0 : 255, 0, 255);
        box(5);
        popStyle();
      }
    };
    nodes[i].randomize();
    nodes[i].setPickingThreshold(20);
  }
  //discard Processing matrices
  resetMatrix();
}

void draw() {
  background(0);
  //resetMatrix();
  graph.preDraw();
  graph.render();
}

void mouseMoved() {
  graph.track(mouseX, mouseY, nodes);
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
  PShader _shader;
  PMatrix3D _pmatrix = new PMatrix3D();

  public GLSLMatrixHandler(Graph graph) {
    super(graph.width(), graph.height());
    _shader = loadShader("frag.glsl", "vert.glsl");
  }

  @Override
  protected void _setUniforms() {
    shader(_shader);
    //_pmatrix.set(Scene.toPMatrix(projectionModelView()));
    //_pmatrix.transpose();
    // same as:
    _pmatrix.set(projectionModelView().get(new float[16]));
    _shader.set("nodes_transform", _pmatrix);
  }
}
