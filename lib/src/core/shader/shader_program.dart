part of ose;

/// Shader program are used by [Filter] and commonly used by GPU itself
/// to launch program with bound attributes & uniforms to make something
/// with your income graphics and out changes to the screen.
class ShaderProgram extends Object with utils.UuidMixin {
  /// Vertex shader.
  final Shader vertexShader;

  /// Fragment shader.
  final Shader fragmentShader;

  /// Attributes.
  final Map<String, Attribute> attributes;

  /// Uniforms.
  final Map<String, Uniform> uniforms;

  /// WebGL program.
  webGL.Program _glProgram;

  /// Create a shader program.
  ShaderProgram(this.vertexShader, this.fragmentShader)
      : attributes = <String, Attribute>{},
        uniforms = <String, Uniform>{};

  webGL.Program get glProgram => _glProgram;

  void set glProgram(webGL.Program glProgram) {
    if (_glProgram != null) {
      throw new Exception('GL program is already set');
    }
    _glProgram = glProgram;
  }

  bool operator ==(ShaderProgram other) => uuid == other.uuid;
}
