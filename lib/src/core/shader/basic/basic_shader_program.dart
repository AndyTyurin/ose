part of ose;

Map<String, Attribute> basicShaderProgramAttributes = {
  'a_color': new Attribute.FloatArray4()
};

final ShaderProgram basicShaderProgram =
    new ShaderProgram(_basicVertexShader, _basicFragmentShader);
