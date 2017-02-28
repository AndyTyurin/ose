part of ose;

/// Shader program is a wrapper around [webGL.Program].
/// It takes role of a scope to keep, link and use both of
/// vertex & fragment shaders, their variables and settings.
///
/// To figure out what is a webgl shader program, usage & examples, look at
/// https://developer.mozilla.org/ru/docs/Web/API/WebGLProgram
class ShaderProgram extends Object with utils.UuidMixin {
  /// Attributes.
  final Map<String, Attribute> attributes;

  /// Uniforms.
  final Map<String, Uniform> uniforms;

  /// Vertex shader.
  Shader _vShader;

  /// Fragment shader.
  Shader _fShader;

  /// WebGL program.
  webGL.Program _glProgram;

  /// Create a new shader program from shader's sources,
  /// where [vSource] is vertex shader's source,
  /// [fSource] is fragment shader's source.
  factory ShaderProgram(String vSource, String fSource) {
    return new ShaderProgram._internal(vSource, fSource);
  }

  /// Create a new shader program from [p].
  factory ShaderProgram.from(ShaderProgram p) {
    return p.clone();
  }

  ShaderProgram._internal(String vSource, String fSource)
      : attributes = <String, Attribute>{},
        uniforms = <String, Uniform>{} {
    _initShadersFromSource(vSource, fSource);
  }

  /// Clone shader program with diverse [uuid].
  ShaderProgram clone() {
    return new ShaderProgram(_vShader.source, _fShader.source);
  }

  bool operator ==(ShaderProgram other) => uuid != other.uuid;

  void _initShadersFromSource(String vSource, String fSource) {
    /// tbd @andytyurin create shaders from [Shader], compile & link.
  }

  webGL.Program get glProgram => _glProgram;

  Shader get vertexShader => _vShader;

  Shader get fragmentShader => _fShader;
}
