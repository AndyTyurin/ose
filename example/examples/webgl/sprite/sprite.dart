import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'dart:async';

import 'package:vector_math/vector_math.dart';

Program program;
int vertexAttribPos;
int textureAttribPos;
double aspect;
Buffer vBuffer;
Buffer tBuffer;
RenderingContext gl;
CanvasElement canvas;
Matrix4 pMatrix;
Matrix4 mvMatrix;
Texture texture;


main() async {
	canvas = new CanvasElement(
		width: window.document.documentElement.clientWidth,
		height: window.document.documentElement.clientHeight
	);

	window.document.documentElement.append(canvas);

	gl = initGL(canvas);

	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	gl.enable(DEPTH_TEST);
	gl.blendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA);
	gl.enable(BLEND);
	gl.depthFunc(LEQUAL);
	gl.viewport(0, 0, canvas.width, canvas.height);
	gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);


	initShaders(gl);
	initBuffers(gl);
	await initTexture(gl);

	init();

}

RenderingContext initGL(CanvasElement canvas) {
	return canvas.getContext3d();
}


void initShaders(RenderingContext gl) {
	program = gl.createProgram();
	gl.attachShader(program, getShader(gl, 'fs'));
	gl.attachShader(program, getShader(gl, 'vs'));
	gl.linkProgram(program);

	if (!gl.getProgramParameter(program, LINK_STATUS)) {
		print('couldn\'t be linked');
		return;
	}

	gl.useProgram(program);

	vertexAttribPos = gl.getAttribLocation(program, 'aVertexPosition');
	gl.enableVertexAttribArray(vertexAttribPos);
	textureAttribPos = gl.getAttribLocation(program, 'aTexturePosition');
	gl.enableVertexAttribArray(textureAttribPos);
}

Shader getShader(RenderingContext gl, String id) {
	Element shaderContainer = document.getElementById(id);
	String shaderType = shaderContainer.getAttribute('type');
	Shader shader = gl.createShader((shaderType == 'x-shader/x-fragment') ? FRAGMENT_SHADER : VERTEX_SHADER);
	gl.shaderSource(shader, shaderContainer.firstChild.text);
	gl.compileShader(shader);

	if (!gl.getShaderParameter(shader, COMPILE_STATUS)) {
		print('shader couldn\'t be compiled');
		return null;
	}

	return shader;

}

void initBuffers(RenderingContext gl) {

	vBuffer = gl.createBuffer();
	tBuffer = gl.createBuffer();
	gl.bindBuffer(ARRAY_BUFFER, vBuffer);

	Float32List vertices = new Float32List.fromList([
		1.0, 1.0,
		-1.0, 1.0,
		1.0, -1.0,
		-1.0, -1.0
	]);

	gl.bufferData(ARRAY_BUFFER, vertices, STATIC_DRAW);

	gl.bindBuffer(ARRAY_BUFFER, tBuffer);

	Float32List textures = new Float32List.fromList([
		1.0, 0.0,
		0.0, 0.0,
		1.0, 1.0,
		0.0, 1.0
	]);

	gl.bufferData(ARRAY_BUFFER, textures, STATIC_DRAW);

}

void setMatrixUniforms(RenderingContext gl) {
	gl.uniformMatrix4fv(gl.getUniformLocation(program, 'uPMatrix'), false, pMatrix.storage);
	gl.uniformMatrix4fv(gl.getUniformLocation(program, 'uMVMatrix'), false, mvMatrix.storage);
}

Future initTexture(RenderingContext gl) async {
	Completer completer = new Completer();
	texture = gl.createTexture();
	ImageElement image = new ImageElement(src: 'i/spaceship.png');
	image.onLoad.listen((e) {
		handleTexture(image, texture);
		print('texture prepared');
		completer.complete();
	});
	return completer.future;

}

void handleTexture(ImageElement image, Texture texture) {
	gl.bindTexture(TEXTURE_2D, texture);
	gl.pixelStorei(UNPACK_FLIP_Y_WEBGL, 1);
	gl.texImage2D(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, image);
	gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, LINEAR);
	gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, LINEAR_MIPMAP_NEAREST);
	gl.generateMipmap(TEXTURE_2D);
	gl.bindTexture(TEXTURE_2D, null);
}

init() {

	print('render invoked');

	gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);

	aspect = canvas.width / canvas.height;

	pMatrix = makeOrthographicMatrix(
		-aspect, aspect,
		1.0, -1.0,
		-1.0, 1.0);
	mvMatrix = new Matrix4.identity()..scale(0.35);

	gl.bindBuffer(ARRAY_BUFFER, vBuffer);
	gl.vertexAttribPointer(vertexAttribPos, 2, FLOAT, false, 0, 0);
	gl.bindBuffer(ARRAY_BUFFER, tBuffer);
	gl.vertexAttribPointer(textureAttribPos, 2, FLOAT, false, 0, 0);
	setMatrixUniforms(gl);
	gl.activeTexture(TEXTURE0);
	gl.bindTexture(TEXTURE_2D, texture);
	gl.uniform1i(gl.getUniformLocation(program, "uSampler"), 0);
	gl.drawArrays(TRIANGLE_STRIP, 0, 4);

	render();
}

render([num dt]) {
	gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
	pMatrix.setTranslation(new Vector3(0.5, 0.0, 0.0));
	mvMatrix.rotateZ(0.01);
	gl.bindBuffer(ARRAY_BUFFER, vBuffer);
	gl.vertexAttribPointer(vertexAttribPos, 2, FLOAT, false, 0, 0);
	gl.bindBuffer(ARRAY_BUFFER, tBuffer);
	gl.vertexAttribPointer(textureAttribPos, 2, FLOAT, false, 0, 0);
	setMatrixUniforms(gl);
	gl.activeTexture(TEXTURE0);
	gl.bindTexture(TEXTURE_2D, texture);
	gl.uniform1i(gl.getUniformLocation(program, "uSampler"), 0);
	gl.drawArrays(TRIANGLE_STRIP, 0, 4);

	window.animationFrame.then(render);
}