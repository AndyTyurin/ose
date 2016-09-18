part of ose;

Map<String, Attribute> _spriteShaderProgramAttributes = {
  'a_position': new Attribute.FloatArray2(),
  'a_color': new Attribute.FloatArray4()
};

Map<String, Uniform> _spriteShaderProgramUniforms = {
  'u_model': new Uniform.Mat3(),
  'u_projection': new Uniform.Mat3()
};

final ShaderProgram spriteShaderProgram = new ShaderProgram(
    _spriteVertexShader,
    _spriteFragmentShader,
    _spriteShaderProgramAttributes,
    _spriteShaderProgramUniforms);
