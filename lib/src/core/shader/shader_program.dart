// todo: uniform & attribute handling is undone and must be completed.

part of ose.core.shader;

class ShaderProgram {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Shader manager.
  static ShaderManager _shaderManager;

  /// WebGL program.
  webGL.Program _program;

  /// Vertex shader.
  Shader _vShader;

  /// Fragment shader.
  Shader _fShader;

  /// Program name.
  String _name;

  /// Uniforms.
  Map<String, Uniform> uniforms;

  /// Attributes.
  Map<String, Attribute> attributes;

  /// Create a shader program.
  ShaderProgram(ShaderManager shaderManager,
      this._name, this._vShader, this._fShader) {
    _program = gl.createProgram();
    gl.attachShader(_program, _vShader.shader);
    gl.attachShader(_program, _fShader.shader);

    // Checks is program successfully compiled.
    if (!gl.getProgramParameter(_program, webGL.LINK_STATUS)) {
      throw new Exception("Coundn't compile program \'${ _name }\'");
    }
  }

  /// Use program.
  void use() {
    gl.useProgram(_program);
  }
}
