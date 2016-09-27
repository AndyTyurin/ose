part of ose;

const String _fragmentSpriteShaderSource = "precision mediump float;"
    "uniform sampler2D u_texture;"
    "uniform vec4 u_texBounds;"
    "varying vec2 v_texCoord;"
    "void main() {"
    "if (v_texCoord.s < u_texBounds.x || v_texCoord.t < u_texBounds.y || v_texCoord.s > u_texBounds.z || v_texCoord.t > u_texBounds.w) {"
    "discard;"
    "}"
    "gl_FragColor = texture2D(u_texture, v_texCoord);"
    "}";

final Shader _spriteFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentSpriteShaderSource);
