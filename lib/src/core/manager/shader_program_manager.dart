/// SPM manages shader programs as well as keeps link to active one.
///
/// Be familiar with [ShaderProgram] engine's implementation variant of
/// shader program.
///
/// Note, that only one shader program can be bound per draw, but usually
/// multiply are used to show up pretty graphics.
///
/// There are two cases when you need to use multply shader programs for
/// one renderable target:
/// * Apply post-processing, which is covered by [Filter];
/// * Particle systems (not implemented yet).
///
/// Each shader program must be registered before usage. It gives flexibility
/// of controlling all programs at once to make some batch operations at
/// preparation stage (PS).

part of ose;

class ShaderProgramManager {
  final Map<String, ShaderProgram> shaderPrograms;

  ShaderProgram _boundShaderProgram;

  ShaderProgramManager() : shaderPrograms = <String, ShaderProgram>{};

  /// Bind specific shader program by [name].
  /// Only added shader programs can be bound.
  /// Use [add] to add shader before binding.
  void bindShaderProgram(String name) {
    if (shaderPrograms.containsKey(name)) {
      _boundShaderProgram = shaderPrograms[name];
    }
  }

  /// Add shader program.
  /// Returns [true] if has been added, [false] if not.
  bool add(String name, ShaderProgram shaderProgram) {
    if (shaderPrograms.containsKey(name)) return false;
    shaderPrograms[name] = shaderProgram;
    return true;
  }

  /// Remove shader program.
  /// Returns [true] if has been removed, [false] if not.
  bool remove(dynamic name) {
    if (shaderPrograms.containsKey(name)) {
      shaderPrograms.remove(name);
      return true;
    }
    return false;
  }

  ShaderProgram get boundShaderProgram => _boundShaderProgram;
}
