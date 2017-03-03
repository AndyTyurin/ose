/// SPM manages shader programs as well as keeps link to active one.
///
/// By using of [register] method, a new shader program can be created and kept.
/// Each shader program must be registered before usage. It gives flexibility
/// of controlling all programs at once to make some batch operations at
/// preparation stage.
///
/// Note, that only one shader program can be bound per draw, but usually
/// multiply are used to show up pretty graphics.
///
/// There are two cases when you need to use multply shader programs for
/// one renderable target:
/// * Apply post-processing, which is covered by [Filter];
/// * Particle systems (not implemented yet).
///
part of ose;

class ShaderProgramManager {
  /// WebGL rendering context.
  final webGL.RenderingContext context;

  /// Map with list of shader program and unique key.
  final Map<String, ShaderProgram> shaderPrograms;

  /// Shader program that is currently bound.
  ShaderProgram _boundShaderProgram;

  ShaderProgramManager(this.context)
      : shaderPrograms = <String, ShaderProgram>{};

  /// Bind shader program by [name].
  /// Only registered shader programs can be bound.
  void bind(String name) {
    if (!shaderPrograms.containsKey(name)) {
      window.console.error('Could not bind non registered \'${name}\' program');
      return;
    }
    _boundShaderProgram = shaderPrograms[name];
    _boundShaderProgram.bind();
  }

  /// Unbind shader program.
  void unbind() {
    _boundShaderProgram.unbind();
  }

  /// Register a new shader program.
  /// New shader program will be created and registered by using of
  /// unique key [name] and shader sources, such as
  /// vertex source [vSource] and fragment source [fSource].
  void register(String name, String vSource, String fSource) {
    if (shaderPrograms.containsKey(name)) {
      window.console
          .warn("Program#${shaderPrograms[name].uuid} already registered");
      return;
    }
    ShaderProgram program = _createShaderProgram(vSource, fSource);

    if (program == null) {
      window.console.error("Could not register program");
      return;
    }

    shaderPrograms[name] = program;
  }

  /// Remove shader program.
  /// Returns [true] if has been removed, [false] if not.
  bool remove(dynamic name) {
    if (shaderPrograms.containsKey(name)) {
      if (shaderPrograms[name] == _boundShaderProgram) {
        window.console.warn("Can not remove bound shader program \'${name}\'");
        return false;
      }
      shaderPrograms.remove(name);
      return true;
    }
    return false;
  }

  ShaderProgram _createShaderProgram(String vSource, String fSource) {
    return new ShaderProgram(context, vSource, fSource);
  }

  ShaderProgram get boundShaderProgram => _boundShaderProgram;
}
