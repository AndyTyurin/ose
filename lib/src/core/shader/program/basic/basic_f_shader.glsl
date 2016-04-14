precision mediump float;

uniform sampler2D u_texSampler2d;

varying vec2 v_texCoord;

void main() {
    gl_FragColor = texture2D(u_texSampler2d, vec2(v_texCoord.s, v_texCoord.t));
}