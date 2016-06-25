part of ose;

/// Shader Program Manager.
///
/// Creates a new shader programs either to cache already exists.
class ShaderProgramManager {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  static final ShaderProgramManager _singleton =
      new ShaderProgramManager._internal();

  factory ShaderProgramManager() {
    return ShaderProgramManager._singleton;
  }

  ShaderProgramManager._internal();

  /// Active shader program uuid.
  ///
  /// Only one shader program can be an active at the same time.
  String activeShaderProgramUuid;

  /// List of programs.
  Map<String, ShaderProgram> _programs = <String, ShaderProgram>{};

  /// Create shader program.
  ///
  /// [vShaderPath] is path to vertex shader.
  /// [fShaderPath] is path to fragment shader.
  Future<ShaderProgram> create(String vShaderPath, String fShaderPath) async {
    return await Future.wait([
      ShaderManager.create(vShaderPath, ShaderType.Vertex),
      ShaderManager.create(fShaderPath, ShaderType.Fragment)
    ]).then((List<Shader> shaders) {
      return new ShaderProgram(shaders[0], shaders[1]);
    });
  }

  /// Use program.
  ///
  /// Only one program can be in use in same time.
  void use(ShaderProgram shaderProgram) {
    if (ShaderProgramManager.activeShaderProgramUuid != shaderProgram.uuid) {
      ShaderProgramManager.activeShaderProgramUuid = shaderProgram.uuid;
      gl.useProgram(shaderProgram.program);
    }
  }

  Map<String, ShaderProgram> get programs => _programs;
}

enum ShaderPrograms { Basic }
