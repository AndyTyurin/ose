part of ose_webgl;

const String _fragmentShapeShaderSource = "precision mediump float;"
    "varying vec4 v_color;"
    "void main() {"
    "gl_FragColor = v_color;"
    "}";

final Shader _shapeFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentShapeShaderSource);
