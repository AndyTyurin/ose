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
/// You shouldn't use shared program manager directly from your code,
/// the renderer use it automatically whenever it's needed.
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
    if (!isRegistered(name)) {
      window.console.error('Could not bind non registered \'${name}\' program');
      return;
    }
    // Unbind currently bound shader program and set next one.
    if (_boundShaderProgram != shaderPrograms[name]) {
      _boundShaderProgram?.unbind();
      _boundShaderProgram = shaderPrograms[name];
    }
    // Bind shader program, attributes & uniforms.
    _boundShaderProgram.bind();
  }

  /// Unbind shader program.
  void unbind() {
    _boundShaderProgram.unbind();
  }

  /// Register a new shader program.
  bool register(String name, String vSource, String fSource,
      {Map<String, Attribute> attributes,
      Map<String, Uniform> uniforms,
      bool useCommonDefinitions}) {
    if (isRegistered(name)) {
      window.console
          .warn("Program#${shaderPrograms[name].uuid} already registered");
      return false;
    }
    ShaderProgram program = new ShaderProgram(context, vSource, fSource,
        attributes: attributes,
        uniforms: uniforms,
        useCommonDefinitions: useCommonDefinitions);

    if (program == null) {
      window.console.error("Could not register program");
      return false;
    }

    shaderPrograms[name] = program;
    return true;
  }

  /// Remove shader program.
  /// Returns [true] if has been removed, [false] if not.
  bool remove(dynamic name) {
    if (shaderPrograms.containsKey(name)) {
      if (_boundShaderProgram == shaderPrograms[name]) {
        window.console.warn("Can not remove bound shader program \'${name}\'");
        return false;
      }
      shaderPrograms.remove(name);
      return true;
    }
    return false;
  }

  bool isRegistered(String name) {
    return shaderPrograms.containsKey(name);
  }

  ShaderProgram get boundShaderProgram => _boundShaderProgram;
}
