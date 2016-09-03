part of ose_webgl;

Map<String, Attribute> _shapeShaderProgramAttributes = {
  'a_position': new Attribute.FloatArray2(),
  'a_color': new Attribute.FloatArray4()
};

Map<String, Uniform> _shapeShaderProgramUniforms = {
  'u_model': new Uniform.Mat3(),
  'u_projection': new Uniform.Mat3()
};

final ShaderProgram shapeShaderProgram = new ShaderProgram(
    _shapeVertexShader,
    _shapeFragmentShader,
    _shapeShaderProgramAttributes,
    _shapeShaderProgramUniforms);
