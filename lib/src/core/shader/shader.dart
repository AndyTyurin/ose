part of ose;

/// Shader represents a peace of program, that will execute code on GPU part.
/// The current implementation is a wrapper around webgl shader and keeps info
/// about shader's source & type. It seems useful for [ShaderProgram].
///
/// [Shader] constructor will initialize webgl shader by compiling.
/// If an error occurs, the compiling error message will be shown.
///
/// You haven't to create it manually, as a [ShaderProgram] do it by itself.
/// Basically you do not need to interact with [Shader] directly at all.
class Shader extends Object with utils.UuidMixin {
  /// WebGL rendering context.
  final webGL.RenderingContext context;

  /// Shader source.
  final String source;

  /// Shader type.
  /// [ShaderType.Vertex] or [ShaderType.Fragment].
  final ShaderType type;

  /// WebGL shader.
  webGL.Shader glShader;

  /// Create a new shader wrapper.
  Shader(this.context, this.type, this.source) {
    _initWebGLShader(type, source);
  }

  /// Initialize webgl shader.
  void _initWebGLShader(ShaderType type, String source) {
    webGL.Shader shader = context.createShader(_getWebGLShaderType(type));
    context.shaderSource(shader, source);
    context.compileShader(shader);

    // Check compilation status.
    if (!context.getShaderParameter(shader, webGL.COMPILE_STATUS)) {
      window.console.error("Shader#${uuid} could not be compiled");
      window.console.error(context.getShaderInfoLog(shader));
      return;
    }

    glShader = shader;
  }

  /// Map [ShaderType] to specific webgl vertex or fragment type.
  int _getWebGLShaderType(ShaderType type) {
    return (type == ShaderType.Vertex)
        ? webGL.VERTEX_SHADER
        : webGL.FRAGMENT_SHADER;
  }
}

enum ShaderType { Vertex, Fragment }
