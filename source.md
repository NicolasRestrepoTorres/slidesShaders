<section id="themes">
	<h2>Themes</h2>
		<p>
			Set your presentation theme: <br>
			<!-- Hacks to swap themes after the page has loaded. Not flexible and only intended for the reveal.js demo deck. -->
                        <a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/black.css'); return false;">Black (default)</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/white.css'); return false;">White</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/league.css'); return false;">League</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/sky.css'); return false;">Sky</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/beige.css'); return false;">Beige</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/simple.css'); return false;">Simple</a> <br>
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/serif.css'); return false;">Serif</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/blood.css'); return false;">Blood</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/night.css'); return false;">Night</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/moon.css'); return false;">Moon</a> -
			<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/solarized.css'); return false;">Solarized</a>
		</p>
</section>

H:

## SHADERS IN PROCESSING

Andres Colubri & Jean Pierre Charalambos

H:

## Contents

1. Introduction
<!-- .element: class="fragment" data-fragment-index="1"-->
2. Shader design patterns
<!-- .element: class="fragment" data-fragment-index="1"-->
3. The chow mein can
<!-- .element: class="fragment" data-fragment-index="1"-->
4. Color shaders
<!-- .element: class="fragment" data-fragment-index="2"-->
5. Texture shaders
<!-- .element: class="fragment" data-fragment-index="2"-->
6. Light shaders
<!-- .element: class="fragment" data-fragment-index="2"-->
7. Image post-processing shaders
<!-- .element: class="fragment" data-fragment-index="2"-->
8. Screen filters
<!-- .element: class="fragment" data-fragment-index="3"-->
9. Shadertoy
<!-- .element: class="fragment" data-fragment-index="3"-->
10. Shaderbase
<!-- .element: class="fragment" data-fragment-index="3"-->

H:

## Intro: What is a shader?

<li class="fragment">A shader is a program that runs on the GPU (Graphics Processing Unit) and it is controlled by our application (for example a Processing sketch)</li>
<li class="fragment">The language of the shaders in Processing is GLSL (OpenGL Shading Language)</li>

V:

## Intro: History

<li class="fragment">Andres started his involvement with Processing back in 2007 with a couple of libraries called <a href="http://andrescolubri.net/glgraphics_gsvideo/" target="_blank">GLGraphics and GSVideo</a></li>
<li class="fragment">In 2013, <a href="http://andrescolubri.net/processing-2/" target="_blank">Processing 2.0</a> was released and incorporated most of the funcionality of GLGraphics and GSVideo, including shaders, into the core of the language</li>

V:

## Intro: Sample projects
### Generating Utopia, by Stefan Wagner

<iframe src="//player.vimeo.com/video/74066023" width="854" height="510" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

V:

## Intro: Sample projects
### Video portraits, by Sergio Albiac

<iframe src="//player.vimeo.com/video/32760578" width="854" height="510" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

V:

## Intro: Sample projects
### Generative Typography, by Amnon Owed

<iframe src="https://player.vimeo.com/video/101383026" width="854" height="478" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

V:

## Intro: Sample projects
### Unnamed soundsculpture, by Daniel Franke

<iframe src="//player.vimeo.com/video/38840688" width="854" height="510" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

V:

## Intro: Sample projects
### Just Cause 2 visualization, by Jim Blackhurst

<iframe width="854" height="510" src="//www.youtube.com/embed/hEoxaGkNcrg" frameborder="0" allowfullscreen></iframe>

V:

## Intro: Sample projects
### Latent State, thesis project

<iframe src="//player.vimeo.com/video/4806038" width="854" height="469" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

V:

## Intro: The graphics pipeline

<div class="ulist">
    <img src="fig/pipeline.png" alt="pipeline" width="55%" style="float: right">
    <ul style="width: 30%;">
        <p class="fragment" data-fragment-index="1">Vertex shader</p>
        <p class="fragment" data-fragment-index="2">Fragment shader</p>
    </ul>
</div>

V:

## Intro: Shaders GPU execution

The vertex shader is run on *each vertex* sent from the sketch:

```python
for vertex in geometry:
    vertex_shader(vertex)
```

The fragment shader is run on *each pixel* covered by the geometry in our sketch:

```python
for pixel in screen:
    if covered_by_geometry(pixel):
        ouptut_color = fragment_shader(pixel)
```

V:

## Intro: Shader variable types

<li class="fragment">*Uniform* variables are those that remain constant for each vertex in the scene, for example the _projection_ and _modelview_ matrices</li>
<li class="fragment">*Attribute* variables are defined per each vertex, for example the _position_, _normal_, and _color_</li>
<li class="fragment">*Varying* variables allows to relate a vertex attribute to a fragment, using interpolation</li>

N:

* varying variables get interpolated between the vertex and the fragment shader

V:

## Intro: Shader example

[Proscene picking buffer fragment shader](https://github.com/remixlab/proscene/blob/master/data/PickingBuffer.frag)

<img height='400' src='fig/pickingbuffer.png'/>

V:

## Intro: Shader example

[Proscene picking buffer fragment shader](https://github.com/remixlab/proscene/blob/master/data/PickingBuffer.frag)

```glsl
uniform vec3 id;

void main() {
  gl_FragColor = vec4(id, 1.0);
}
```

V:

## Intro: Processing shader API: [PShader](https://processing.org/reference/PShader.html)

> Class that encapsulates a GLSL shader program, including a vertex and a fragment shader

V:

## Intro: Processing shader API: [loadShader()](https://processing.org/reference/loadShader_.html)

> Loads a shader into the PShader object

Method signatures

```processing
  loadShader(fragFilename)
  loadShader(fragFilename, vertFilename)
```
<!-- .element: class="fragment" data-fragment-index="1"-->

Example

```processing
  PShader unalShader;
  void setup() {
    ...
    //when no path is specified it looks in the sketch 'data' folder
    unalShader = loadShader("unal_frag.glsl", "unal_vert.glsl");
  }
```
<!-- .element: class="fragment" data-fragment-index="2"-->

V:

## Intro: Processing shader API: [shader()](https://processing.org/reference/shader_.html)

> Applies the specified shader

Method signature

```processing
  shader(shader)
```
<!-- .element: class="fragment" data-fragment-index="1"-->

Example

```processing
  PShader simpleShader, unalShader;
  void draw() {
    ...
    shader(simpleShader);
    simpleGeometry();
    shader(unalShader);
    unalGeometry();
  }
```
<!-- .element: class="fragment" data-fragment-index="2"-->

V:

## Intro: Processing shader API: [resetShader()](https://processing.org/reference/resetShader_.html)

> Restores the default shaders

Method signatures

```processing
  resetShader()
```
<!-- .element: class="fragment" data-fragment-index="1"-->

Example

```processing
  PShader simpleShader;
  void draw() {
    ...
    shader(simpleShader);
    simpleGeometry();
    resetshader();
    otherGeometry();
  }
```
<!-- .element: class="fragment" data-fragment-index="2"-->

V:

## Intro: Processing shader API: [PShader.set()](https://processing.org/reference/PShader_set_.html)

> Sets the uniform variables inside the shader to modify the effect while the program is running

Method signatures for vector uniform variables `vec2`, `vec3` or `vec4`:

```processing
  .set(name, x)
  .set(name, x, y)
  .set(name, x, y, z)
  .set(name, x, y, z, w)
  .set(name, vec)
```

* *name*: of the uniform variable to modify
* *x*, *y*, *z* and *w*: 1st, snd, 3rd and 4rd vec float components resp.
* *vec*: PVector

V:

## Intro: Processing shader API: [PShader.set()](https://processing.org/reference/PShader_set_.html)

> Sets the uniform variables inside the shader to modify the effect while the program is running

Method signatures for vector uniform variables `boolean[]`, `float[]`, `int[]`:

```processing
  .set(name, x)
  .set(name, x, y)
  .set(name, x, y, z)
  .set(name, x, y, z, w)
  .set(name, vec)
```

* *name*: of the uniform variable to modify
* *x*, *y*, *z* and *w*: 1st, snd, 3rd and 4rd vec (boolean, float or int) components resp.
* *vec*: boolean[], float[], int[]

V:

## Intro: Processing shader API: [PShader.set()](https://processing.org/reference/PShader_set_.html)

> Sets the uniform variables inside the shader to modify the effect while the program is running

Method signatures for `mat3` and `mat4` uniform variables:

```processing
  .set(name, mat) // mat is PMatrix2D, or PMatrix3D
```

* *name* of the uniform variable to modify
* *mat* PMatrix3D, or PMatrix2D

V:

## Intro: Shaders
### Processing shader API: [PShader.set()](https://processing.org/reference/PShader_set_.html)

> Sets the uniform variables inside the shader to modify the effect while the program is running

Method signatures for vector uniform variables:

```processing
  .set(name, tex) // tex is a PImage
```

V:

## Intro: Processing shader API: [PShader.set()](https://processing.org/reference/PShader_set_.html)

> Sets the uniform variables inside the shader to modify the effect while the program is running

Example:

```processing
  PShader unalShader;
  PMatrix3D projectionModelView1, projectionModelView2;
  void draw() {
    ...
    shader(unalShader);
    unalShader.set("unalMatrix", projectionModelView1);
    unalGeometry1();
    unalShader.set("unalMatrix", projectionModelView2);
    unalGeometry2();
  }
```
<!-- .element: class="fragment" data-fragment-index="1"-->

H:

## Shader design patterns

1. Data sent from the sketch to the shaders<!-- .element: class="fragment" data-fragment-index="1"-->
2. Passing data among shaders<!-- .element: class="fragment" data-fragment-index="2"-->
3. Consistency of geometry operations<!-- .element: class="fragment" data-fragment-index="3"-->

V:

## Shader design patterns
### Rule 1: Data sent from the sketch to the shaders

> Processing passes data to the shaders in a context sensitive way

<li class="fragment">Specific data (attribute and uniform vatiables) sent to the GPU depends on the type of shader
<li class="fragment">Data to be sent to the GPU depends on issued Processing commands, e.g., the ```attribute vec4 color``` vertex shader attribute is related to the ```fill(rgb)``` Processing command

V:

## Shader design patterns
### Rule 1: Data sent from the sketch to the shaders
#### Shader types

| Primitive type | Shader type |   Pre-processor #defines   |
|----------------|:-----------:|:--------------------------:|
| Point          | POINT       | PROCESSING_POINT_SHADER    |
| Line           | LINE        | PROCESSING_LINE_SHADER     |
| Triangle       | COLOR       | PROCESSING_COLOR_SHADER    |
| Triangle       | LIGHT       | PROCESSING_LIGHT_SHADER    |
| Triangle       | TEXTURE     | PROCESSING_TEXTURE_SHADER  |
| Triangle       | TEXLIGHT    | PROCESSING_TEXLIGHT_SHADER |

N:

* Processing shader type auto-detection utility

V:

## Shader design patterns
### Rule 2: Passing data among shaders

> Uniform variables are available for both, the vertex and the fragment shader. Attribute variables are only available to the vertex shader

<li class="fragment"> Passing a vertex *attribute* variable to the fragment shader thus requires relating it first to a vertex shader *varying* variable
<li class="fragment"> The vertex and fragment shaders would look like the following:
  ```glsl
  // vert.glsl
  attribute <type> var;
  varying <type> vert_var;
  void main() {
    ...
    vert_var = fx(var);
  }
  ```
  ```glsl
  // frag.glsl
  varying <type> vert_var;
  ```

V:

## Shader design patterns
### Rule 3: Consistency of geometry operations

> Geometry operations should always be carried out under the same reference frame

<li class="fragment"> Tip 1: ```transform * vertex // projection * modelview * vertex``` yields the vertex coordinates in [clip-space](http://www.songho.ca/opengl/gl_transform.html)
<li class="fragment"> Tip 2: ```modelview * vertex``` yields the vertex coordinates in eye-space
<li class="fragment"> Tip 3: Since the eye position is 0 in eye-space, eye-space is the usual reference frame for geometry operations 

H:

## The chow mein can

During the rest of this presentation we will work with the following test scene:

<img width="640" src="fig/chowmein.png">

<li class="fragment"> We will be following the [Processing shader tutorial](https://processing.org/tutorials/pshader/) which source code is available [here](https://github.com/codeanticode/pshader-tutorials)

V:

## The chow mein can
### Code 

```java
PImage label;
PShape can;
float angle;

void setup() {
  size(640, 360, P3D);  
  label = loadImage("lachoy.jpg");
  can = createCan(100, 200, 32, label);
}

void draw() {    
  background(0);
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
```

V:

## The chow mein can
### Texture

<a href="fig/lachoy.jpg" target="_blank"><img width="800" src="fig/lachoy.jpg"></a>

(from Jason Liebig's <a href="http://www.flickr.com/photos/jasonliebigstuff/3739263136/in/photostream/" target="_blank">FLICKR collection</a> of vintage labels and wrappers)

H:

## Color shaders

<figure>
    <img height="400" src="fig/color.png">
    <figcaption>Color shader output (source code available [here](https://github.com/codeanticode/pshader-tutorials/tree/master/intro/Ex_04_2_color))</figcaption>
</figure>

V:

## Color shaders: Design patterns

> Rule 1: Data sent from the sketch to the shaders

([colorvert.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_04_2_color/data/colorvert.glsl) excerpt)
```glsl
...
attribute vec4 color;
```

V:

## Color shaders: Design patterns

> Rule 2: Passing data among shaders

([colorvert.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_04_2_color/data/colorvert.glsl) excerpt)
```glsl
attribute vec4 color;
varying vec4 vertColor;
void main() {
  ...
  vertColor = color;
}
```
<!-- .element: class="fragment" data-fragment-index="1"-->

([colorfrag.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_04_2_color/data/colorfrag.glsl) excerpt)
```glsl
varying vec4 vertColor;
void main() {
  gl_FragColor = vertColor;
}
```
<!-- .element: class="fragment" data-fragment-index="2"-->

H:

## Texture shaders
### Simple texture

<figure>
    <img height="400" src="fig/chowmein.png">
    <figcaption>Texture shader output (source code available [here](https://github.com/codeanticode/pshader-tutorials/tree/master/intro/Ex_05_1_texture))</figcaption>
</figure>

V:

## Texture shaders: Design patterns
### Simple texture

> Rule 1: Data sent from the sketch to the shaders

([texvert.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_05_1_texture/data/texvert.glsl) excerpt)
```glsl
...
uniform mat4 texMatrix;
attribute vec2 texCoord;
```
<!-- .element: class="fragment" data-fragment-index="1"-->

([texfrag.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_05_1_texture/data/texfrag.glsl) excerpt)
```glsl
uniform sampler2D texture;
...
```
<!-- .element: class="fragment" data-fragment-index="2"-->

V:

## Texture shaders: Design patterns
### Simple texture

> Rule 2: Passing data among shaders

([texvert.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_05_1_texture/data/texvert.glsl) excerpt)
```glsl
...
uniform mat4 texMatrix;
attribute vec2 texCoord;
varying vec4 vertTexCoord;
void main() {
  ...
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
```
<!-- .element: class="fragment" data-fragment-index="1"-->

([texfrag.glsl](https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_05_1_texture/data/texfrag.glsl) excerpt)
```glsl
uniform sampler2D texture;
varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
}
```
<!-- .element: class="fragment" data-fragment-index="2"-->

N:

The texture * vertColor product is consistent:
* vertColor is in [0..1]
* texture2D(texture, vertTexCoord.st) is also in [0..1]

V:

## Texture shaders
### Pixelation effect

<figure>
    <img height="400" src="fig/bintex.png">
    <figcaption>Pixelation shader output</figcaption>
</figure>

V:

## Texture shaders
### Pixelation effect

We can sample the texels in virtually any way we want, and this allow us to create different types of effects. For example, we can discretize the texture coordinates as follows:

```glsl
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  int si = int(vertTexCoord.s * 50.0);
  int sj = int(vertTexCoord.t * 50.0);  
  gl_FragColor = texture2D(texture, vec2(float(si) / 50.0, float(sj) / 50.0)) * vertColor;  
}
```

V:

## Texture shaders
### Pixelation effect
#### [Pixelator.pde](https://github.com/VisualComputing/Shaders/blob/gh-pages/sketches/desktop/Pixelator/Pixelator.pde) code

The constant 50 can be converted into an *uniform* variable (```binsize```) to be controlled from the sketch:

```java
PImage label;
PShape can;
float angle;

PShader pixelator;

void setup() {
  size(640, 360, P3D);  
  label = loadImage("lachoy.jpg");
  can = createCan(100, 200, 32, label);
  pixelator = loadShader("pixel.glsl");
}

void draw() {    
  background(0);

  pixelator.set("binsize", 100.0 * float(mouseX) / width);
  shader(pixelator);
    
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
```

V:

## Texture shaders
### Pixelation effect
#### [pixel.glsl](https://github.com/VisualComputing/Shaders/blob/gh-pages/sketches/desktop/Pixelator/data/pixel.glsl) code

```glsl
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float binsize;

void main() {
  int si = int(vertTexCoord.s * binsize);
  int sj = int(vertTexCoord.t * binsize);  
  gl_FragColor = texture2D(texture, vec2(float(si) / binsize, float(sj) / binsize)) * vertColor;  
}
```

H:

## Light shaders



H:

### Creating image filters

By changing the way the pixels of a texture are processed in the fragment shader, we can create different image filters. So, we can modify our sample code to add a custom B&W shader:

```java
PImage label;
PShape can;
float angle;

PShader bwShader;

void setup() {
  size(640, 360, P3D);  
  label = loadImage("lachoy.jpg");
  can = createCan(100, 200, 32, label);
  bwShader = loadShader("bwfrag.glsl");
}

void draw() {    
  background(0);
  
  shader(bwShader);
    
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
```

V:

Let's look at the bwfrag.glsl code:

```glsl
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec4 col = texture2D(texture, vertTexCoord.st);
  float lum = dot(col, lumcoeff);
  if (0.5 < lum) {
    gl_FragColor = vertColor;
  } else {
    gl_FragColor = vec4(0, 0, 0, 1);
  }     
}
```

V:

We read the texture pixel (also called as *texel*) at the position determined by the texture coordinate vertTexCoord.st:

```glsl
vec4 col = texture2D(texture, vertTexCoord.st);
```

and then calculate the luminance of the texel by taking the dot product with the vector of the luminance coefficients:

```glsl
float lum = dot(col, lumcoeff);
```

If the luminance is above of below the 0.5 threshold, we output either white or black:

```glsl
  if (0.5 < lum) {
    gl_FragColor = vertColor;
  } else {
    gl_FragColor = vec4(0, 0, 0, 1);
  }   
```

V:

We should get something like:

<img width="640" src="fig/bw.png">

H:

### Convolution filters

<a href="http://lodev.org/cgtutor/filtering.html" target="_blank">Convolution filters</a> can be implemented in the fragment shader. Given the texture coordinates of a fragment, *vertTexCoord*, the neighboring texels can be sampled using the *texOffset* uniform. 

*texOffset = vec2(1/width, 1/height)*

For example, *vertTexCoord.st + vec2(texOffset.s, 0)* is the texel exactly one position to the right.

V:

#### Edge detection shader

```glsl
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);
  vec4 col6 = texture2D(texture, tc6);
  vec4 col7 = texture2D(texture, tc7);
  vec4 col8 = texture2D(texture, tc8);

  vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor; 
}
```

V:

<img width="640" src="fig/edges.png">

V:

#### Emboss shader

```glsl
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc3 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(texture, tc0);
  vec4 col1 = texture2D(texture, tc1);
  vec4 col2 = texture2D(texture, tc2);
  vec4 col3 = texture2D(texture, tc3);
  vec4 col4 = texture2D(texture, tc4);
  vec4 col5 = texture2D(texture, tc5);

  vec4 sum = vec4(0.5) + (col0 + col1 + col2) - (col3 + col4 + col5);
  float lum = dot(sum, lumcoeff);
  gl_FragColor = vec4(lum, lum, lum, 1.0) * vertColor;  
}
```

V:

<img width="640" src="fig/emboss.png">

H:

## Lighting

Lighting a 3D scene involves placing one or more light sources in the space, and defining their parameters, such as type (point, spotlight) and color (diffuse, ambient, specular). In the simplest model of lighting, the intensity at each vertex is computed as the dot product between the vertex normal and the direction vector between the vertex and light positions. This model represents a point light source that emits light equally in all directions: 

<img width="360" src="fig/lighting.png">

V:

We now specify both the vertex and the fragment shaders:

```java
PShape can;
float angle;

PShader lightShader;

void setup() {
  size(640, 360, P3D);
  can = createCan(100, 200, 32);
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {    
  background(0);

  shader(lightShader);

  pointLight(255, 255, 255, width/2, height, 200);

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
```

V:

The vertex shader handles the lighting math per each vertex:

```glsl
uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;

void main() {
  gl_Position = transformMatrix * position;    
  vec3 ecVertex = vec3(modelviewMatrix * position);  
  vec3 ecNormal = normalize(normalMatrix * normal);

  vec3 direction = normalize(lightPosition.xyz - ecVertex);    
  float intensity = max(0.0, dot(direction, ecNormal));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;             
}
```

V:

In the vertex shader, the ecVertex variable is the position of the input vertex expressed in eye-coordinates, since it is obtained by multiplying vertex by the modelview matrix. Similarly, multiplying the input normal vector by the normalMatrix yields its coordinates in the eye-system. 

Once all the vectors are expressed in the same coordinate system, they can be used to calculate the intensity of the incident light at the current vector. From the formula used in the shader, the intensity is directly proportional to the angle between the normal and the vector between the vertex and the light source.

V:

And the fragment shader is simply a passthrough that receives the computer color per each pixel:

```glsl
varying vec4 vertColor;

void main() {
  gl_FragColor = vertColor;
}
```

V:

<img width="640" src="fig/vertlight.png">

H:

## Combining lights and textures

In order to render a scene with both lights and textures, the shaders simply need to incorporate the corresponding lighting math and the texture sampling.

V:

Sketch code:

```java
PImage label;
PShape can;
float angle;

PShader texlightShader;

void setup() {
  size(640, 360, P3D);  
  label = loadImage("lachoy.jpg");
  can = createCan(100, 200, 32, label);
  texlightShader = loadShader("texlightfrag.glsl", "texlightvert.glsl");
}

void draw() {    
  background(0);
  
  shader(texlightShader);

  pointLight(255, 255, 255, width/2, height, 200);  
    
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
```

V:

Vertex shader:

```glsl
uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transformMatrix * position;    
  vec3 ecVertex = vec3(modelviewMatrix * position);  
  vec3 ecNormal = normalize(normalMatrix * normal);

  vec3 direction = normalize(lightPosition.xyz - ecVertex);    
  float intensity = max(0.0, dot(direction, ecNormal));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;     
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);        
}
```

V:

Fragment shader:

```glsl
uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
}
```

V:

<img width="640" src="fig/texlight.png">

H:

## Screen filters
### Using fragment shaders

We can also apply any of the image post-processing effects to an arbitrary
Processing sketch using the ```filter()``` function and passing a PShader argument to it

For example, to apply the [emboss shader as a screen filter](https://github.com/VisualComputing/Shaders/tree/gh-pages/sketches/desktop/ScreenFilter):

```java
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
```

Note that the ```filter()``` call is done after drawing all the geometry

H:

## Shadertoy

[Shadertoy shaders](https://www.shadertoy.com/) are purely procedural: no geometry is sent from the main application,
and all the scene is generated in the fragment shader:

<a href="https://www.shadertoy.com/view/MdX3Rr" target="_blank"><img width="480" src="fig/elevated.png"></a>

V:

## Shadertoy
### Running Shadertoy shaders in Processing

These shaders can be easily run in Processing by defining a layer between Processing and Shadertoy uniforms:

```glsl
// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

// Layer between Processing and Shadertoy uniforms
vec3 iResolution = vec3(resolution,0.0);
float iGlobalTime = time;
vec4 iMouse = vec4(mouse,0.0,0.0); // zw would normally be the click status

// ------- Below is the unmodified Shadertoy code ----------
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

//stereo thanks to Croqueteer
//#define STEREO 

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

vec3 noised( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    vec2 u = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    float a = hash(n+  0.0);
    float b = hash(n+  1.0);
    float c = hash(n+ 57.0);
    float d = hash(n+ 58.0);
	return vec3(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y,
				30.0*f*f*(f*(f-2.0)+1.0)*(vec2(b-a,c-a)+(a-b-c+d)*u.yx));

}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                    mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);

    return res;
}

float fbm( vec3 p )
{
    float f = 0.0;

    f += 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

mat2 m2 = mat2(1.6,-1.2,1.2,1.6);
	
float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.5000*noise( p ); p = m2*p*2.02;
    f += 0.2500*noise( p ); p = m2*p*2.03;
    f += 0.1250*noise( p ); p = m2*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

float terrain( in vec2 x )
{
	vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
	vec2  d = vec2(0.0);
    for(int i=0;i<5; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d,d));
		b *= 0.5;
        p=mat2(1.6,-1.2,1.2,1.6)*p;
    }

    return 140.0*a;
}

float terrain2( in vec2 x )
{
	vec2  p = x*0.003;
    float a = 0.0;
    float b = 1.0;
	vec2  d = vec2(0.0);
    for(int i=0;i<14; i++)
    {
        vec3 n = noised(p);
        d += n.yz;
        a += b*n.x/(1.0+dot(d,d));
		b *= 0.5;
        p=m2*p;
    }

    return 140.0*a;
}

float map( in vec3 p )
{
	float h = terrain(p.xz);
	
	float ss = 0.03;
	float hh = h*ss;
	float fh = fract(hh);
	float ih = floor(hh);
	fh = mix( sqrt(fh), fh, smoothstep(50.0,140.0,h) );
	h = (ih+fh)/ss;
	
    return p.y - h;
}

float map2( in vec3 p )
{
	float h = terrain2(p.xz);

	
	float ss = 0.03;
	float hh = h*ss;
	float fh = fract(hh);
	float ih = floor(hh);
	fh = mix( sqrt(fh), fh, smoothstep(50.0,140.0,h) );
	h = (ih+fh)/ss;
	
    return p.y - h;
}

bool jinteresct(in vec3 rO, in vec3 rD, out float resT )
{
    float h = 0.0;
    float t = 0.0;
	for( int j=0; j<120; j++ )
	{
        //if( t>2000.0 ) break;
		
	    vec3 p = rO + t*rD;
if( p.y>300.0 ) break;
        h = map( p );

		if( h<0.1 )
		{
			resT = t; 
			return true;
		}
		t += max(0.1,0.5*h);

	}

	if( h<5.0 )
    {
	    resT = t;
	    return true;
	}
	return false;
}

float sinteresct(in vec3 rO, in vec3 rD )
{
    float res = 1.0;
    float t = 0.0;
	for( int j=0; j<50; j++ )
	{
        //if( t>1000.0 ) break;
	    vec3 p = rO + t*rD;

        float h = map( p );

		if( h<0.1 )
		{
			return 0.0;
		}
		res = min( res, 16.0*h/t );
		t += h;

	}

	return clamp( res, 0.0, 1.0 );
}

vec3 calcNormal( in vec3 pos, float t )
{
	float e = 0.001;
	e = 0.001*t;
    vec3  eps = vec3(e,0.0,0.0);
    vec3 nor;
    nor.x = map2(pos+eps.xyy) - map2(pos-eps.xyy);
    nor.y = map2(pos+eps.yxy) - map2(pos-eps.yxy);
    nor.z = map2(pos+eps.yyx) - map2(pos-eps.yyx);
    return normalize(nor);
}

vec3 camPath( float time )
{
    vec2 p = 600.0*vec2( cos(1.4+0.37*time), 
                         cos(3.2+0.31*time) );

	return vec3( p.x, 0.0, p.y );
}

void main(void)
{
    vec2 xy = -1.0 + 2.0*gl_FragCoord.xy / iResolution.xy;

	vec2 s = xy*vec2(1.75,1.0);

	#ifdef STEREO
	float isCyan = mod(gl_FragCoord.x + mod(gl_FragCoord.y,2.0),2.0);
    #endif
	
    float time = iGlobalTime*.15;

	vec3 light1 = normalize( vec3(  0.4, 0.22,  0.6 ) );
	vec3 light2 = vec3( -0.707, 0.000, -0.707 );

	vec3 campos = camPath( time );
	vec3 camtar = camPath( time + 3.0 );
	campos.y = terrain( campos.xz ) + 15.0;
	camtar.y = campos.y*0.5;

	float roll = 0.1*cos(0.1*time);
	vec3 cw = normalize(camtar-campos);
	vec3 cp = vec3(sin(roll), cos(roll),0.0);
	vec3 cu = normalize(cross(cw,cp));
	vec3 cv = normalize(cross(cu,cw));
	vec3 rd = normalize( s.x*cu + s.y*cv + 1.6*cw );

	#ifdef STEREO
	campos += 2.0*cu*isCyan; // move camera to the right - the rd vector is still good
    #endif

	float sundot = clamp(dot(rd,light1),0.0,1.0);
	vec3 col;
    float t;
    if( !jinteresct(campos,rd,t) )
    {
     	col = 0.9*vec3(0.97,.99,1.0)*(1.0-0.3*rd.y);
		col += 0.2*vec3(0.8,0.7,0.5)*pow( sundot, 4.0 );
	}
	else
	{
		vec3 pos = campos + t*rd;

        vec3 nor = calcNormal( pos, t );

		float dif1 = clamp( dot( light1, nor ), 0.0, 1.0 );
		float dif2 = clamp( 0.2 + 0.8*dot( light2, nor ), 0.0, 1.0 );
		float sh = 1.0;
		if( dif1>0.001 ) 
			sh = sinteresct(pos+light1*20.0,light1);
		
		vec3 dif1v = vec3(dif1);
		dif1v *= vec3( sh, sh*sh*0.5+0.5*sh, sh*sh );

		float r = noise( 7.0*pos.xz );

        col = (r*0.25+0.75)*0.9*mix( vec3(0.10,0.05,0.03), vec3(0.13,0.10,0.08), clamp(terrain2( vec2(pos.x,pos.y*48.0))/200.0,0.0,1.0) );
		col = mix( col, 0.17*vec3(0.5,.23,0.04)*(0.50+0.50*r),smoothstep(0.70,0.9,nor.y) );
        col = mix( col, 0.10*vec3(0.2,.30,0.00)*(0.25+0.75*r),smoothstep(0.95,1.0,nor.y) );
  	    col *= 0.75;
         // snow
        #if 1
		float h = smoothstep(55.0,80.0,pos.y + 25.0*fbm(0.01*pos.xz) );
        float e = smoothstep(1.0-0.5*h,1.0-0.1*h,nor.y);
        float o = 0.3 + 0.7*smoothstep(0.0,0.1,nor.x+h*h);
        float s = h*e*o;
        s = smoothstep( 0.1, 0.9, s );
        col = mix( col, 0.4*vec3(0.6,0.65,0.7), s );
        #endif
		
		vec3 brdf  = 2.0*vec3(0.17,0.19,0.20)*clamp(nor.y,0.0,1.0);
		     brdf += 6.0*vec3(1.00,0.95,0.80)*dif1v;
		     brdf += 2.0*vec3(0.20,0.20,0.20)*dif2;

		col *= brdf;
		
		float fo = 1.0-exp(-pow(0.0015*t,1.5));
		vec3 fco = vec3(0.7) + 0.6*vec3(0.8,0.7,0.5)*pow( sundot, 4.0 );
		col = mix( col, fco, fo );
	}

	col = sqrt(col);

	vec2 uv = xy*0.5+0.5;
	col *= 0.7 + 0.3*pow(16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y),0.1);
	
    #ifdef STEREO	
    col *= vec3( isCyan, 1.0-isCyan, 1.0-isCyan );	
	#endif
	
	gl_FragColor=vec4(col,1.0);
}
```

V:

## Shadertoy
### Running Shadertoy shaders in Processing

The sketch code is very simple, just the uniform setting and a rect covering the entire window to make sure that all the pixels in the screen pass through the fragment shader:

```java
PShader shader;

void setup() {
  size(640, 360, P2D);
  noStroke();
  shader = loadShader("landscape.glsl");
  shader.set("resolution", float(width), float(height));   
}

void draw() {
  background(0);
    
  shader.set("time", (float)(millis()/1000.0));
  shader(shader); 
  rect(0, 0, width, height);
}
```

H:

## Shaderbase
### Creating and sharing shaders

<li class="fragment"> This is an on-going [collaboration](https://github.com/remixlab/shaderbase)
<li class="fragment"> The goal is to create a Processing tool that allows users to upload shaders to a github-based db

<img width="640" src="fig/ShaderBase.png">

H:

## References

* [The Book of Shaders, by Patricio Gonzalez Vivo](http://patriciogonzalezvivo.com/2015/thebookofshaders/)
* [Processing shaders tutorial](https://www.processing.org/tutorials/pshader/)
* [Tutorial source code](https://github.com/codeanticode/pshader-tutorials)
* [Shader Programming for Computational Arts and Design - A Comparison between Creative Coding Frameworks](http://www.scitepress.org/DigitalLibrary/PublicationsDetail.aspx?ID=ysaclbloDHk=&t=1)
* [ShaderBase: A Processing Tool for Shaders in Computational Arts and Design](http://www.scitepress.org/DigitalLibrary/Link.aspx?doi=10.5220/0005673201890194) (source code [available here](https://github.com/remixlab/shaderbase))
