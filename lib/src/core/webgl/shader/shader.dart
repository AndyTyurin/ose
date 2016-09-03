part of ose_webgl;

class Shader {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// WebGL shader.
  webGL.Shader _shader;

  /// Shader source.
  String _source;

  /// Shader type.
  ///
  /// [ShaderType.Vertex] or [ShaderType.Fragment].
  ShaderType _type;

  /// Create new shader.
  ///
  /// [_type] is [ShaderType.Vertex] or [ShaderType.Fragment].
  /// [_source] is shader source.
  Shader(this._type, this._source) {
    // Checks is shader source is not empty.
    if (Shader._isShaderLoaded(_source, _type)) {
      _shader = gl.createShader(Shader._mapToWebGLShaderType(_type));
      gl.shaderSource(_shader, _source);
      gl.compileShader(_shader);

      // Checks shader compile status.
      if (!gl.getShaderParameter(_shader, webGL.COMPILE_STATUS)) {
        throw new Exception("Couldn't compile"
            " ${ _getShaderNameByType(_type) } shader");
      }
    }
  }

  /// Get shader name.
  ///
  /// [type] can be [ShaderType.Vertex] or [ShaderType.Fragment].
  /// Commonly used to fetch name of the shader by type (Vertex or Fragment).
  static String _getShaderNameByType(ShaderType type) {
    return (type == ShaderType.Vertex) ? 'Vertex' : 'Fragment';
  }

  /// Check is shader loaded.
  ///
  /// [source] is shader source.
  /// [type] is type of a shader, [ShaderType.Vertex] or [ShaderType.Fragment].
  /// Throw [Exception] if shader source is an empty.
  static bool _isShaderLoaded(String source, ShaderType type) {
    if (source.isEmpty) {
      throw new Exception("${ _getShaderNameByType(type) }"
          " shader couldn't be loaded");
    }
    return true;
  }

  /// Get webGL shader type.
  static int _mapToWebGLShaderType(ShaderType type) {
    if (type == ShaderType.Fragment) return webGL.FRAGMENT_SHADER;
    return webGL.VERTEX_SHADER;
  }

  webGL.Shader get shader => _shader;

  String get source => _source;

  ShaderType get type => _type;
}

/// Shader types.
enum ShaderType { Vertex, Fragment }
