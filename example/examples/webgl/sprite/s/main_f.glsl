precision highp float;

varying highp vec2 vTexturePosition;

uniform sampler2D uSampler;

void main(void) {
    gl_FragColor = texture2D(uSampler, vec2(vTexturePosition.s, vTexturePosition.t));
}