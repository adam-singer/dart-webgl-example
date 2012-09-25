// We revert to dart:dom cause Float32Array does not have constructor in dart:html https://code.google.com/p/dart/issues/detail?id=560
#import('dart:html');
// This was borrowed from http://code.google.com/p/dart/source/browse/branches/bleeding_edge/dart/samples/matrix/matrix_client.dart
#import('matrix_client.dart');
class webglexample {

  webglexample() {
  }

  void run() {
    CanvasElement canvas = document.query("canvas");
    WebGLRenderingContext gl = canvas.getContext("experimental-webgl");

    gl.viewport(0, 0, canvas.width, canvas.height);

    // Create fragment shader
    WebGLShader fragShader = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
    String strfragShader = """
    precision mediump float;

    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }""";
    gl.shaderSource(fragShader, strfragShader);
    gl.compileShader(fragShader);

    // Create vertext shader
    WebGLShader vertShader = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
    String strvertShader = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
""";
    gl.shaderSource(vertShader, strvertShader);
    gl.compileShader(vertShader);

    // Create shader program
    WebGLProgram shaderProgram = gl.createProgram();
    gl.attachShader(shaderProgram, vertShader);
    gl.attachShader(shaderProgram, fragShader);
    gl.linkProgram(shaderProgram);
    gl.useProgram(shaderProgram);

    int vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
    gl.enableVertexAttribArray(vertexPositionAttribute);

    WebGLUniformLocation pMatrixUniform  = gl.getUniformLocation(shaderProgram, "uPMatrix");
    WebGLUniformLocation mvMatrixUniform  = gl.getUniformLocation(shaderProgram, "uMVMatrix");


    // init buffers
    WebGLBuffer triangleVertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, triangleVertexPositionBuffer);
    var vertices = [
                          0.0,  1.0,  0.0,
                         -1.0, -1.0,  0.0,
                          1.0, -1.0,  0.0
                     ];
    Float32Array floa = new Float32Array.fromList(vertices);
    gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, floa, WebGLRenderingContext.STATIC_DRAW);


    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(WebGLRenderingContext.DEPTH_TEST);

    // draw  scene
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);

    //var mvMatrix = new Matrix4();
    //var pMatrix = new Matrix4();

    var pMatrix = Matrix4.perspective(45.0, canvas.width/canvas.height, 0.1, 100.0);
    var mvMatrix = Matrix4.translation(new Vector3(-1.5, 0.0, -7.0));

    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, triangleVertexPositionBuffer);
    gl.vertexAttribPointer(vertexPositionAttribute, 3, WebGLRenderingContext.FLOAT, false, 0, 0);
    gl.uniformMatrix4fv(pMatrixUniform, false, pMatrix.buf);
    gl.uniformMatrix4fv(mvMatrixUniform, false, mvMatrix.buf);
    gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, 3);

    //write("Hello World!");
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    //document.query('#status').innerHTML = message;
    LabelElement l = document.query('#status'); //  = message;
    l.text = message;
  }
}

void main() {
  new webglexample().run();
}
