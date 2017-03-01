part of ose;

const String shaderVertexHeaderDefinitions = ""
    "#ifdef GL_VERTEX_PRECISION_HIGH\n"
    "precision highp float;\n"
    "precision highp int;\n"
    "#else\n"
    "precision mediump float;\n"
    "precision mediump int;\n"
    "#endif\n"
    // Vertex position.
    "attribute vec2 a_position;"
    // Texel position.
    "attribute vec2 a_texCoord;"
    // Model matrix.
    "uniform mat3 u_m;"
    // View matrix.
    "uniform mat3 u_v;"
    // Projection matrix.
    "uniform mat3 u_p;";

const String shaderFragmentHeaderDefinitions = ""
    "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
    "precision highp float;\n"
    "precision highp int;\n"
    "#else\n"
    "precision mediump float;\n"
    "precision mediump int;\n"
    "#endif\n";

/// Shader program is a wrapper around [webGL.Program].
/// It keeps attributes, uniforms, initialize webgl program and shaders.
///
/// To create a custom [ShaderProgram], use [ShaderProgramManager.create]
/// instead of using constructor.
class ShaderProgram extends Object with utils.UuidMixin {
  /// WebGL rendering context.
  final webGL.RenderingContext context;

  /// Attributes.
  final Map<String, Attribute> attributes;

  /// Uniforms.
  final Map<String, Uniform> uniforms;

  /// WebGL program.
  webGL.Program glProgram;

  /// Vertex shader.
  Shader _vShader;

  /// Fragment shader.
  Shader _fShader;

  ShaderProgram(this.context, String vSource, String fSource)
      : attributes = <String, Attribute>{},
        uniforms = <String, Uniform>{} {
    _initShaderProgram(vSource, fSource);
  }

  void _initShaderProgram(String vSource, String fSource) {
    bool isShadersCompiled = _initShadersFromSource(vSource, fSource);

    if (isShadersCompiled) {
      // Create webgl program.
      webGL.Program program = context.createProgram();

      // Attach shaders to webgl program.
      context.attachShader(program, _vShader.glShader);
      context.attachShader(program, _fShader.glShader);

      // Link the program.
      context.linkProgram(program);

      // Check is compilation has been without any errors.
      if (context.getProgramParameter(program, webGL.LINK_STATUS)) {
        window.console.error("Program${uuid} could not be linked");
        window.console.error(context.getProgramInfoLog(program));
        return;
      }

      glProgram = program;
    }
  }

  bool _initShadersFromSource(String vSource, String fSource) {
    // Apply common header definitions to shaders.
    vSource = _applyHeaderToShaderSource(ShaderType.Vertex, vSource);
    fSource = _applyHeaderToShaderSource(ShaderType.Fragment, fSource);

    // Create vertex & fragment shaders.
    _vShader = new Shader(context, ShaderType.Vertex, vSource);
    _fShader = new Shader(context, ShaderType.Fragment, vSource);

    if (_vShader == null || _fShader == null) return false;

    return true;
  }

  String _applyHeaderToShaderSource(ShaderType type, String source) {
    String headerDefinitions = (type == ShaderType.Vertex)
        ? shaderVertexHeaderDefinitions
        : shaderFragmentHeaderDefinitions;
    return "${headerDefinitions}\n${source}";
  }

  bool operator ==(ShaderProgram other) => uuid != other.uuid;

  Shader get vertexShader => _vShader;

  Shader get fragmentShader => _fShader;
}
