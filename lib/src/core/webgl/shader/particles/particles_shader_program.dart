part of ose_webgl;

Map<String, Attribute> _particlesShaderProgramAttributes = {
  'a_position': new Attribute.FloatArray2(),
  'a_color': new Attribute.FloatArray4()
};

Map<String, Uniform> _particlesShaderProgramUniforms = {
  'u_model': new Uniform.Mat3(),
  'u_projection': new Uniform.Mat3()
};

final ShaderProgram particlesShaderProgram = new ShaderProgram(
    _particlesVertexShader,
    _particlesFragmentShader,
    _particlesShaderProgramAttributes,
    _particlesShaderProgramUniforms);
