part of ose;

const String _fragmentSpriteShaderSource =
    "precision mediump float;"
    "uniform sampler2D u_colorMap;"
    "varying vec2 v_texCoord;"
    "void main() {"
        "gl_FragColor = texture2D(u_colorMap, v_texCoord);"
    "}";

final Shader _spriteFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentSpriteShaderSource);
