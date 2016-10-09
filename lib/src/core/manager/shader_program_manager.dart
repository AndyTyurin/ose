part of ose;

class ShaderProgramManager {
  ShaderProgram _activeShaderProgram;

  ShaderProgram get activeShaderProgram => _activeShaderProgram;

  void set activeShaderProgram(ShaderProgram shaderProgram) {
    _activeShaderProgram = shaderProgram;
  }
}
