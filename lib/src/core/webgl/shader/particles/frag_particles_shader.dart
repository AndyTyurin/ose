part of ose_webgl;

const String _fragmentParticlesShaderSource = "precision mediump float;"
    "varying vec4 v_color;"
    "void main() {"
    "gl_FragColor = v_color;"
    "}";

final Shader _particlesFragmentShader =
    new Shader(ShaderType.Fragment, _fragmentParticlesShaderSource);
