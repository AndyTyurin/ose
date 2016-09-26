part of ose;

Map<String, Attribute> _spriteShaderProgramAttributes = {
  'a_position': new Attribute.FloatArray2(),
  'a_texCoord': new Attribute.FloatArray2()
};

Map<String, Uniform> _spriteShaderProgramUniforms = {
  'u_model': new Uniform.Mat3(),
  'u_projection': new Uniform.Mat3(),
  'u_texture': new Uniform.Int1(0),
  'u_texBounds': new Uniform.Float4()
};

final ShaderProgram spriteShaderProgram = new ShaderProgram(
    _spriteVertexShader,
    _spriteFragmentShader,
    _spriteShaderProgramAttributes,
    _spriteShaderProgramUniforms);
