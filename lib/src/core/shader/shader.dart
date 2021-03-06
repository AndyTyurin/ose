part of ose;

/// There is a shader wrapper for webgl shaders that is commonly used
/// by shader programs.
/// There are two types of shaders - vertex & fragment shaders.
/// Basically shader wrapper keeps content that will be launched by GPU.
class Shader {

  /// WebGL shader.
  webGL.Shader _glShader;

  /// Shader source.
  String _source;

  /// Shader type.
  /// [ShaderType.Vertex] or [ShaderType.Fragment].
  ShaderType _type;

  /// Create new shader.
  /// [_type] is [ShaderType.Vertex] or [ShaderType.Fragment].
  /// [_source] is shader source.
  Shader(this._type, this._source);

  webGL.Shader get glShader => _glShader;

  void set glShader(webGL.Shader glShader) {
    if (_glShader != null) {
      throw new Exception('WebGL shader already set');
    }
    _glShader = glShader;
  }

  String get source => _source;

  ShaderType get type => _type;
}

/// Shader types.
enum ShaderType { Vertex, Fragment }
