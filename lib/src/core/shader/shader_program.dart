part of ose;

/// Shader program is affect to how is render works.
/// By specify shader sources, attributes and uniforms, render could be worked
/// by another way, as well as several shader programs could be used per tick.
class ShaderProgram extends Object with utils.UuidMixin {
  /// Vertex shader.
  final Shader vertexShader;

  /// Fragment shader.
  final Shader fragmentShader;

  /// Uniforms.
  final Map<String, Uniform> uniforms;

  /// Attributes.
  final Map<String, Attribute> attributes;

  /// WebGL program.
  webGL.Program _glProgram;

  /// Create a shader program.
  ShaderProgram(this.vertexShader, this.fragmentShader,
      [Map<String, Attribute> attributes, Map<String, Uniform> uniforms])
      : attributes = attributes ?? new Map<String, Attribute>(),
        uniforms = uniforms ?? new Map<String, Uniform>();

  webGL.Program get glProgram => _glProgram;

  void set glProgram(webGL.Program glProgram) {
    if (_glProgram != null) {
      throw new Exception('GL program is already set');
    }
    _glProgram = glProgram;
  }
}
