part of ose_webgl;

// TODO: Re-factor shader program.
// TODO: Re-work [ShaderProgram.use].

class ShaderProgram {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Unique id.
  String _uuid;

  /// WebGL program.
  webGL.Program _program;

  /// Vertex shader.
  Shader _vShader;

  /// Fragment shader.
  Shader _fShader;

  /// Uniforms.
  Map<String, Uniform> uniforms;

  /// Attributes.
  Map<String, Attribute> attributes;

  /// Create a shader program.
  ShaderProgram(this._vShader, this._fShader) {
    this._uuid = utils.generateUuid();
    this._program = gl.createProgram();
    this.uniforms = <String, Uniform>{};
    this.attributes = <String, Attribute>{};

    gl.attachShader(this._program, this._vShader.shader);
    gl.attachShader(this._program, this._fShader.shader);
    gl.linkProgram(this._program);

    // Checks is program successfully compiled.
    if (!gl.getProgramParameter(this._program, webGL.LINK_STATUS)) {
      throw new Exception("Coundn't compile program");
    }
  }

  /// Apply attributes.
  ///
  /// Iterate through attributes and initialize them.
  void applyAttributes() {
    this.attributes.forEach((name, attribute) {
      this._applyAttribute(name, attribute);
    });
  }

  /// Apply attribute.
  void _applyAttribute(String name, Attribute attribute, [int location]) {
    if (!attribute.isChanged) return;

    if (attribute.location == null) {
      if (location != null) {
        gl.bindAttribLocation(this._program, location, name);
        attribute.location = location;
      } else {
        attribute.location = gl.getAttribLocation(this._program, name);
      }
    }

    int attributeLocation = attribute.location;
    bool useBuffer = attribute.useBuffer;
    List attributeStorage = attribute.storage;
    int attributeSize = 1;

    switch (attribute.type) {
      case Type.Float1:
        if (useBuffer) break;
        gl.vertexAttrib1f(attributeLocation, attributeStorage[0]);
        break;
      case Type.Float2:
        if (useBuffer) {
          attributeSize = 2;
          break;
        }
        gl.vertexAttrib2f(
            attributeLocation, attributeStorage[0], attributeStorage[1]);
        break;
      case Type.Float3:
        if (useBuffer) {
          attributeSize = 3;
          break;
        }
        gl.vertexAttrib3f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2]);
        break;
      case Type.Float4:
        if (useBuffer) {
          attributeSize = 4;
          break;
        }
        gl.vertexAttrib4f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2], attributeStorage[3]);
        break;
      default:;
    }

    if (attribute.useBuffer) {
      _initBuffer(attribute.buffer, attribute.storage, attribute.isChanged);
      gl.enableVertexAttribArray(attributeLocation);
      gl.vertexAttribPointer(
          attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
    }

    // Attributes remembers that it was changed in past.
    // Changed state takes main role in checking do we need to send values
    // to GPU or not. After send we should reset changed state flag.
    attribute.resetChangedState();
  }

  /// Initialize buffer.
  ///
  /// Method is invoked by [_applyAttribute] if attribute need a buffer.
  void _initBuffer(webGL.Buffer buffer, Float32List storage, bool isChanged) {
    gl.bindBuffer(webGL.ARRAY_BUFFER, buffer);
    if (isChanged) {
      gl.bufferData(webGL.ARRAY_BUFFER, storage, webGL.STATIC_DRAW);
    }
  }

  /// Apply uniforms.
  ///
  /// Iterate for each uniform and initialize them.
  void applyUniforms() {
    uniforms.forEach((name, uniform) {
      this._applyUniform(name, uniform);
    });
  }

  /// Apply uniform.
  void _applyUniform(String name, Uniform uniform) {
    if (!uniform.isChanged) return;

    if (uniform.location == null) {
      uniform.location = gl.getUniformLocation(this._program, name);
    }

    webGL.UniformLocation uniformLocation = uniform.location;

    List uniformStorage = uniform.storage;

    switch (uniform.type) {
      case Type.Int1:
        if (uniform.useArray) {
          gl.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case Type.Float1:
        if (uniform.useArray) {
          gl.uniform1fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform1f(uniformLocation, uniformStorage[0]);
        break;
      case Type.Float2:
        if (uniform.useArray) {
          gl.uniform2fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform2f(uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case Type.Float3:
        if (uniform.useArray) {
          gl.uniform3fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform3f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case Type.Float4:
        if (uniform.useArray) {
          gl.uniform4fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform4f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case Type.Mat2:
        gl.uniformMatrix2fv(uniformLocation, false, uniformStorage);
        break;
      case Type.Mat3:
        gl.uniformMatrix3fv(uniformLocation, false, uniformStorage);
        break;
      default:;
    }

    // Uniform remembers that it was changed in past.
    // Changed state takes main role in checking do we need to send values
    // to GPU or not. After send we should reset changed state flag.
    uniform.resetChangedState();
  }

  /// Apply texture.
  void applyTexture(Texture texture) {
    texture.bind();
  }

  /// Remove texture.
  void removeTexture(Texture texture) {
    gl.deleteTexture(texture.texture);
  }

  /// Use program.
  ///
  /// Only one program can be in use in same time.
  ///
  void use() {
    ShaderProgramManager.use(this);
  }

  String get uuid => _uuid;

  webGL.Program get program => _program;
}


/// Attribute, uniforms types.
enum Type {
  Float1, Float2, Float3, Float4,
  Int1,
  Mat2, Mat3
}
