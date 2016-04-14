part of ose.core.shader;

/// Used to create new WebGL programs and keep them for further usage
class ShaderProgramManager {
  /// WebGL Rendering Context
  static webGL.RenderingContext gl;

  /// Shader manager.
  static ShaderManager _shaderManager;

  /// List with available programs.
  ///
  /// Only one of them can be used as an active.
  /// Each program has unique name.
  Map<String, ShaderProgram> _programs;

  /// Current an active program (has been used in render).
  ///
  /// Note that program must be present in programs list.
  ShaderProgram _program;

  /// Create new program manager.
  ShaderProgramManager(ShaderManager shaderManager) {
    _shaderManager = shaderManager;
  }

  /// Create new program and keep it inside field.
  ///
  /// Use [name] to define shader program name.
  /// [vShaderPath] and [fShaderPath] are paths to shader files.
  Future<ShaderProgram> create(
      String name, String vShaderPath, String fShaderPath) async {
    Shader vShader;
    Shader fShader;

    // Loads shader async.
    await Future.wait([
      _shaderManager.create(vShaderPath, webGL.VERTEX_SHADER),
      _shaderManager.create(fShaderPath, webGL.FRAGMENT_SHADER)
    ]).then((List<Shader> shaders) {
      vShader = shaders[0];
      fShader = shaders[1];
    });

    // Keep program in list.
    return _programs[name] =
        new ShaderProgram(_shaderManager, name, vShader, fShader);
  }

  /// Use program.
  ///
  /// Throw [Exception] if program not found in list.
  void use(String programName) {
    ShaderProgram program = _programs[programName];

    if (_program == program) return;

    if (program == null) {
      throw new Exception('Shader program \'${ programName }\''
          'is not found. Create new one before.');
    }

    program.use();
  }

  ShaderProgram get program => _program;

  Map<String, ShaderProgram> get programs => _programs;
}
