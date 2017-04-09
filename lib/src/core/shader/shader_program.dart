part of ose;

/// Common vertex header definitions.
/// It will be applied to each propagated shader on program initialization.
///
/// There are several common attriubtes & uniforms available in vertex shader:
/// * Attribute vec2 a_position – current position;
/// * Uniform mat3 u_m – model matrix;
/// * Uniform mat3 u_v - view matrix;
/// * Uniform mat3 u_p - projection matrix.
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
    // Model matrix.
    "uniform mat3 u_m;"
    // View matrix.
    "uniform mat3 u_v;"
    // Projection matrix.
    "uniform mat3 u_p;"
    "uniform int z_index;";

/// Common fragment header definitions.
/// It will be applied to each propagated shader on program initialization.
///
/// There are several common uniforms available in fragment shader:
/// * Uniform mat3 u_m – model matrix;
/// * Uniform mat3 u_v - view matrix;
/// * Uniform mat3 u_p - projection matrix.
const String shaderFragmentHeaderDefinitions = ""
    "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
    "precision highp float;\n"
    "precision highp int;\n"
    "#else\n"
    "precision mediump float;\n"
    "precision mediump int;\n"
    "#endif\n"
    // Model matrix.
    "uniform mat3 u_m;"
    // View matrix.
    "uniform mat3 u_v;"
    // Projection matrix.
    "uniform mat3 u_p;";

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

  /// Map uniform identifiers with their locations.
  /// Give a little bit optimization advantage, because cache locations
  /// and re-use them instead of calling getting uniform locations each
  /// render.
  final Map<String, webGL.UniformLocation> _uniformLocations;

  /// Should common defintions applied to shaders' sources.
  final useCommonDefinitions;

  /// Shaders' sources options will be passed and interpolated from variables
  /// to string representation data.
  final Map<String, String> templateVariables;

  /// WebGL program.
  webGL.Program glProgram;

  /// Vertex shader.
  Shader _vShader;

  /// Fragment shader.
  Shader _fShader;

  bool _isBound;

  /// Create a new shader program by using passed [webGL.RenderingContext],
  /// and shader sources, vertex source [vSource] and fragment source [fSource].
  ShaderProgram(this.context, String vSource, String fSource,
      {this.useCommonDefinitions: true, this.templateVariables})
      : attributes = <String, Attribute>{},
        uniforms = <String, Uniform>{},
        _uniformLocations = <String, webGL.UniformLocation>{} {
    init(vSource, fSource, templateVariables);
  }

  /// Initialize shader program.
  /// Prepare attributes & uniforms of a shader program to work before
  /// it will be used.
  void init(String vSource, String fSource, Map<String, String> templateVariables) {
    _initShaderProgram(vSource, fSource, templateVariables);
  }

  /// Release allocated resources.
  void release() {
    attributes.clear();
    uniforms.clear();
    context.detachShader(glProgram, _vShader.glShader);
    context.detachShader(glProgram, _fShader.glShader);
    context.deleteShader(_vShader.glShader);
    context.deleteShader(_fShader.glShader);
    context.deleteProgram(glProgram);
    _vShader = null;
    _fShader = null;
    glProgram = null;
  }

  /// Bind shader program.
  void bind() {
    _bindProgram();
    _bindUniforms();
    _bindAttributes();
  }

  /// Unbind shader program.
  /// It's required to use it before switching to another shader program.
  /// That logic must be handled by [ShaderProgramManager].
  void unbind() {
    _isBound = false;
  }

  /// Bind program if it's necessary.
  void _bindProgram() {
    if (!_isBound) {
      context.useProgram(glProgram);
    }
    _isBound = true;
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
      // Value hasn't been changed and already kept in buffer,
      // it's not necessary to bind & change buffer.
      if (attribute.state == QualifierState.CACHED) return;

      context.bindBuffer(webGL.ARRAY_BUFFER, attribute.glBuffer);

      // Enable vertex attribute array & pointer at initial.
      if (attribute.state == QualifierState.INITIALIZED) {
        context.enableVertexAttribArray(attributeLocation);
        context.vertexAttribPointer(
            attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
      }

      context.bufferData(
          webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
    }
  }

  /// Generate attribute locations.
  void _generateAttributeLocations() {
    attributes.forEach((name, attribute) {
      _generateAttributeLocation(name, attribute);
    });
  }

  /// Generate attribute location if hasn't been defined yet.
  void _generateAttributeLocation(String name, Attribute attribute) {
    if (attribute.location == null) {
      attribute.location = context.getAttribLocation(glProgram, name);
    }
  }

  /// Initialize attributes.
  void _initAttributes() {
    attributes.forEach((name, attribute) {
      _initAttribute(name, attribute);
    });
  }

  /// Initialize attribute.
  /// Set up location & create a buffer if needs.
  void _initAttribute(String name, Attribute attribute) {
    // Bind attribute location to program.
    if (attribute.location != null) {
      context.bindAttribLocation(glProgram, attribute.location, name);
    }
    // Create and keep [attribute.glBuffer].
    if (attribute.shouldUseBuffer && attribute.glBuffer == null) {
      attribute.glBuffer = context.createBuffer();
    }
  }

  /// Bind uniforms.
  void _bindUniforms() {
    uniforms.forEach((name, uniform) {
      _bindUniform(name, uniform);
    });
  }

  /// Bind uniform.
  void _bindUniform(String name, Uniform uniform) {
    // Do not apply any changes to uniform if there are no changes.
    if (uniform.state == QualifierState.CACHED) return;

    // Retrive and keep uniform location inside uniform wrapper.
    if (_uniformLocations[name] == null) {
      _uniformLocations[name] = context.getUniformLocation(glProgram, name);
    }

    webGL.UniformLocation uniformLocation = _uniformLocations[name];
    List uniformStorage = uniform.storage;

    switch (uniform.type) {
      case QualifierType.Bool1:
        if (uniform.useArray) {
          context.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Int1:
        if (uniform.useArray) {
          uniformStorage = new Int32List.fromList(uniformStorage);
          context.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Int2:
        if (uniform.useArray) {
          context.uniform2iv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform2i(
            uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case QualifierType.Int3:
        if (uniform.useArray) {
          context.uniform3iv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform3i(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case QualifierType.Int4:
        if (uniform.useArray) {
          context.uniform4iv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform4i(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case QualifierType.Float1:
        if (uniform.useArray) {
          context.uniform1fv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform1f(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Float2:
        if (uniform.useArray) {
          context.uniform2fv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform2f(
            uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case QualifierType.Float3:
        if (uniform.useArray) {
          context.uniform3fv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform3f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case QualifierType.Float4:
        if (uniform.useArray) {
          context.uniform4fv(uniformLocation, uniformStorage);
          break;
        }
        context.uniform4f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case QualifierType.Mat2:
        context.uniformMatrix2fv(uniformLocation, false, uniformStorage);
        break;
      case QualifierType.Mat3:
        context.uniformMatrix3fv(uniformLocation, false, uniformStorage);
        break;
      default:
        ;
    }
  }

  void _initShaderProgram(
      String vSource, String fSource, Map<String, String> templateVariables) {
    bool isShadersCompiled =
        _initShadersFromSource(vSource, fSource, templateVariables);

    if (isShadersCompiled) {
      // Create webgl program.
      webGL.Program program = context.createProgram();

      // Attach shaders to webgl program.
      context.attachShader(program, _vShader.glShader);
      context.attachShader(program, _fShader.glShader);

      // Initialize attributes by creating buffers and setting static locations.
      _initAttributes();

      // Link the program.
      context.linkProgram(program);

      // Generate other attribute locations.
      _generateAttributeLocations();

      // Check is compilation has been without any errors.
      if (context.getProgramParameter(program, webGL.LINK_STATUS)) {
        window.console.error("Program${uuid} could not be linked");
        window.console.error(context.getProgramInfoLog(program));
        return;
      }

      glProgram = program;
    }
  }

  /// Create & initialize shaders from their sources.
  bool _initShadersFromSource(
      String vSource, String fSource, Map<String, String> templateVariables) {
    if (useCommonDefinitions) {
      // Prepare shader sources.
      vSource = _prepareShaderSource(ShaderType.Vertex, vSource, templateVariables);
      fSource =
          _prepareShaderSource(ShaderType.Fragment, fSource, templateVariables);
    }

    // Create vertex & fragment shaders.
    _vShader = new Shader(context, ShaderType.Vertex, vSource);
    _fShader = new Shader(context, ShaderType.Fragment, vSource);

    if (_vShader == null || _fShader == null) return false;

    return true;
  }

  /// Prepare shader' source by interpolate data with [templateVariables] and
  /// applying common definitions to header if it needed.
  String _prepareShaderSource(
      ShaderType type, String source, Map<String, String> templateVariables) {
    return _applyHeaderToShaderSource(
        type, _interpolateShaderSource(source, templateVariables));
  }

  /// Interpolate shader options' variables to source content.
  String _interpolateShaderSource(
      String source, Map<String, String> templateVariables) {
    templateVariables.keys.forEach((option) {
      String v = templateVariables[option];
      source = source.replaceAll(option, v);
    });
    return source;
  }

  /// Apply common header definitions for specific [type] of [source].
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
