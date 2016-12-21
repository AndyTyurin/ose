part of ose;

/// Shader program manager manages shader programs.
class ShaderProgramManager {
  /// Active shader program.
  ShaderProgram _activeShaderProgram;

  ShaderProgram get activeShaderProgram => _activeShaderProgram;

  void set activeShaderProgram(ShaderProgram shaderProgram) {
    _activeShaderProgram = shaderProgram;
  }
}
