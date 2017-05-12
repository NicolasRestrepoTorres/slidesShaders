PShader emboss;

void setup() {
  size(400, 400, P3D); 
  emboss = loadShader("emboss.glsl");  
}

void draw() {
  background(150);
  lights();
  translate(width/2, height/2);
  rotateX(frameCount * 0.01);
  rotateY(frameCount * 0.01);
  box(100);

  filter(emboss);
}
