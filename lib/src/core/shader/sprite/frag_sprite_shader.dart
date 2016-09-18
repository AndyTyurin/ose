part of ose;

const String _fragmentSpriteShaderSource = "precision mediump float;"
    "varying vec4 v_color;"
    "void main() {"
    "gl_FragColor = v_color;"
    "}";

final Shader _spriteFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentSpriteShaderSource);
