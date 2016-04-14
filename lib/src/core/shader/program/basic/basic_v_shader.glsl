uniform mat4 u_modelViewProjMatrix;

attribute vec3 a_texCoord;
attribute vec2 a_position;

varying vec2 v_texCoord;

void main() {
    gl_Position = u_modelViewProjMatrix * vec4(a_position, 0.0, 1.0);
    v_texCoord = a_texCoord.st;
}