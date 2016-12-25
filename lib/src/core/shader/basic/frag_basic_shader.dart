part of ose;

const String _fragmentBasicShaderSource =
    "precision mediump float;"
    "varying vec4 v_color;"
    "void main() {"
        "gl_FragColor = v_color;"
    "}";

final Shader _basicFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentBasicShaderSource);
