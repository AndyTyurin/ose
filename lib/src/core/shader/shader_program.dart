part of ose;

/// Shader program is affect to how is render works.
/// By specify shader sources, attributes and uniforms, render could be worked
/// by another way, as well as several shader programs could be used per tick.
class ShaderProgram extends Object with utils.UuidMixin {
  /// WebGL program.
  final webGL.Program program;

  /// Vertex shader.
  final Shader _vShader;

  /// Fragment shader.
  final Shader _fShader;

  /// Uniforms.
  final Map<String, Uniform> uniforms;

  /// Attributes.
  final Map<String, Attribute> attributes;

  /// Create a shader program.
  ShaderProgram(this._vShader, this._fShader,
      [Map<String, Attribute> attributes, Map<String, Uniform> uniforms])
      : program = Renderer.gl.createProgram(),
        attributes = attributes ?? new Map<String, Attribute>(),
        uniforms = uniforms ?? new Map<String, Uniform>() {
    Renderer.gl.attachShader(program, _vShader.shader);
    Renderer.gl.attachShader(program, _fShader.shader);
    Renderer.gl.linkProgram(program);

    if (!Renderer.gl.getProgramParameter(program, webGL.LINK_STATUS)) {
      throw new Exception("Coundn't compile program");
    }
  }

  /// Apply attributes.
  /// Iterate through attributes and initialize each one.
  void applyAttributes() {
    attributes.forEach((name, attribute) {
      _applyAttribute(name, attribute);
    });
  }

  /// Apply attribute.
  void _applyAttribute(String name, Attribute attribute) {
    if (!attribute.isChanged) return;

    if (attribute.location != null) {
      Renderer.gl.bindAttribLocation(program, attribute.location, name);
    } else {
      attribute.location = Renderer.gl.getAttribLocation(program, name);
    }

    int attributeLocation = attribute.location;
    bool useBuffer = attribute.useBuffer;
    List attributeStorage = attribute.storage;
    int attributeSize = 1;

    switch (attribute.type) {
      case Type.Float1:
        if (useBuffer) break;
        Renderer.gl.vertexAttrib1f(attributeLocation, attributeStorage[0]);
        break;
      case Type.Float2:
        if (useBuffer) {
          attributeSize = 2;
          break;
        }
        Renderer.gl.vertexAttrib2f(
            attributeLocation, attributeStorage[0], attributeStorage[1]);
        break;
      case Type.Float3:
        if (useBuffer) {
          attributeSize = 3;
          break;
        }
        Renderer.gl.vertexAttrib3f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2]);
        break;
      case Type.Float4:
        if (useBuffer) {
          attributeSize = 4;
          break;
        }
        Renderer.gl.vertexAttrib4f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2], attributeStorage[3]);
        break;
      default:
        ;
    }

    if (attribute.useBuffer) {
      Renderer.gl.bindBuffer(webGL.ARRAY_BUFFER, attribute.buffer);

      if (attribute.isChanged) {
        Renderer.gl.bufferData(
            webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
      }

      Renderer.gl.enableVertexAttribArray(attributeLocation);
      Renderer.gl.vertexAttribPointer(
          attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
    }

    /// Attribute that was changed in past, should kept a state about it.
    /// GPU is checking the state each tick to make decision,
    /// should we propagate data or not. If data has been sent to GPU,
    /// we need to reset the state.
    attribute.resetChangedState();
  }

  /// Apply uniforms.
  /// Iterate through unniforms and initialize each one
  void applyUniforms() {
    uniforms.forEach((name, uniform) {
      _applyUniform(name, uniform);
    });
  }

  /// Apply uniform.
  void _applyUniform(String name, Uniform uniform) {
    if (!uniform.isChanged) return;

    if (uniform.location == null) {
      uniform.location = Renderer.gl.getUniformLocation(program, name);
    }

    webGL.UniformLocation uniformLocation = uniform.location;

    List uniformStorage = uniform.storage;

    switch (uniform.type) {
      case Type.Int1:
        if (uniform.useArray) {
          Renderer.gl.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        Renderer.gl.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case Type.Float1:
        if (uniform.useArray) {
          Renderer.gl.uniform1fv(uniformLocation, uniformStorage);
          break;
        }
        Renderer.gl.uniform1f(uniformLocation, uniformStorage[0]);
        break;
      case Type.Float2:
        if (uniform.useArray) {
          Renderer.gl.uniform2fv(uniformLocation, uniformStorage);
          break;
        }
        Renderer.gl
            .uniform2f(uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case Type.Float3:
        if (uniform.useArray) {
          Renderer.gl.uniform3fv(uniformLocation, uniformStorage);
          break;
        }
        Renderer.gl.uniform3f(uniformLocation, uniformStorage[0],
            uniformStorage[1], uniformStorage[2]);
        break;
      case Type.Float4:
        if (uniform.useArray) {
          Renderer.gl.uniform4fv(uniformLocation, uniformStorage);
          break;
        }
        Renderer.gl.uniform4f(uniformLocation, uniformStorage[0],
            uniformStorage[1], uniformStorage[2], uniformStorage[3]);
        break;
      case Type.Mat2:
        Renderer.gl.uniformMatrix2fv(uniformLocation, false, uniformStorage);
        break;
      case Type.Mat3:
        Renderer.gl.uniformMatrix3fv(uniformLocation, false, uniformStorage);
        break;
      default:
        ;
    }

    /// Uniform that was changed in past, should kept a state about it.
    /// GPU is checking the state each tick to make decision,
    /// should we propagate data or not. If data has been sent to GPU,
    /// we need to reset the state.
    uniform.resetChangedState();
  }
}

/// Attribute, uniforms types.
enum Type { Float1, Float2, Float3, Float4, Int1, Mat2, Mat3 }
