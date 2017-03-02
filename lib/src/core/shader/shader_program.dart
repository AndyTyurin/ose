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
/// To create a custom [ShaderProgram], use [ShaderProgramManager.register]
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

  /// Bind shader program.
  void bind() {
    // tbd @andytyurin to implement uniforms binding.
    // _bindUniforms();
    _bindAttributes();
  }

  /// Bind all attributes.
  void _bindAttributes() {
    attributes.forEach((name, attribute) {
      _bindAttribute(name, attribute);
    });
  }

  /// Bind attribute.
  void _bindAttribute(String name, Attribute attribute) {
    List attributeStorage = attribute.storage;
    int attributeLocation = attribute.location;
    bool shouldUseBuffer = attribute.shouldUseBuffer;
    int attributeSize = 1;

    // Use appropriate setting by qualifier type.
    switch (attribute.type) {
      case QualifierType.Float1:
        if (shouldUseBuffer) break;
        context.vertexAttrib1f(attributeLocation, attributeStorage[0]);
        break;
      case QualifierType.Float2:
        if (shouldUseBuffer) {
          attributeSize = 2;
          break;
        }
        context.vertexAttrib2f(
            attributeLocation, attributeStorage[0], attributeStorage[1]);
        break;
      case QualifierType.Float3:
        if (shouldUseBuffer) {
          attributeSize = 3;
          break;
        }
        context.vertexAttrib3f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2]);
        break;
      case QualifierType.Float4:
        if (shouldUseBuffer) {
          attributeSize = 4;
          break;
        }
        context.vertexAttrib4f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2], attributeStorage[3]);
        break;
      default:
        ;
    }

    // Use buffer for vertex-array values.
    if (attribute.shouldUseBuffer) {
      context.bindBuffer(webGL.ARRAY_BUFFER, attribute.glBuffer);

      // Enable vertex attribute array & pointer at initial.
      if (attribute.state == QualifierState.INITIALIZED) {
        context.enableVertexAttribArray(attributeLocation);
        context.vertexAttribPointer(
            attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
      }

      // Update buffer only the data is new or has been changed since last set.
      if (attribute.state == QualifierState.INITIALIZED ||
          attribute.state == QualifierState.CHANGED) {
        context.bufferData(
            webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
      }
    }
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
