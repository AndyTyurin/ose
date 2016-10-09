part of ose;

class ShaderProgram extends Object with utils.UuidMixin {
  /// Vertex shader.
  final Shader vertexShader;

  /// Fragment shader.
  final Shader fragmentShader;

  /// WebGL program.
  webGL.Program _glProgram;

  /// Create a shader program.
  ShaderProgram(this.vertexShader, this.fragmentShader);

  webGL.Program get glProgram => _glProgram;

  void set glProgram(webGL.Program glProgram) {
    if (_glProgram != null) {
      throw new Exception('GL program is already set');
    }
    _glProgram = glProgram;
  }

  bool operator ==(ShaderProgram other) => uuid == other.uuid;
}
