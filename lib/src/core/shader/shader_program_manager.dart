part of ose;

/// Shader Program Manager is singleton interface is used to control
/// defined shaders prorgams, basically set up an active.
class ShaderProgramManager {
  /// Singleton initialization.
  static final ShaderProgramManager _singleton =
      new ShaderProgramManager._internal();

  /// UUID of a bound shader program.
  /// Only one shader program can be an active at the same time.
  String _boundShaderProgramId;

  /// List of available programs.
  Map<String, ShaderProgram> _programs = <String, ShaderProgram>{};

  /// Get singleton.
  factory ShaderProgramManager() => ShaderProgramManager._singleton;

  ShaderProgramManager._internal();

  static ShaderProgramManager getInstance() => ShaderProgramManager._singleton;

  /// Bind shader program.
  /// Only one program can be bound in same time.
  void bindProgram(ShaderProgram shaderProgram) {
    if (shaderProgram.uuid != _boundShaderProgramId) {
      _boundShaderProgramId = shaderProgram.uuid;
      Renderer.gl.useProgram(shaderProgram.program);
    }
  }

  // void bindTexture(Texture texture) {
  //   // TODO: Write texture binding feature.
  // }
  //
  // void unbindTexture() {
  //   // TODO: Write texture unbinding feature.
  // }

  Map<String, ShaderProgram> get programs => _programs;
}
