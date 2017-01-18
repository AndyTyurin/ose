part of ose;

/// Uniform manages manages uniforms.
class UniformManager {
  /// Equality tool for lists.
  static final Function eq = const ListEquality().equals;

  /// Previous uniforms.
  final Map<String, Uniform> prevUniforms;

  /// Next uniforms.
  final Map<String, Uniform> nextUniforms;

  final Set<String> ignoreUniforms;

  /// Rendering context.
  webGL.RenderingContext _gl;

  UniformManager(this._gl)
      : prevUniforms = <String, Uniform>{},
        nextUniforms = <String, Uniform>{},
        ignoreUniforms = new Set<String>();

  /// Bind uniforms.
  void bindUniforms(ShaderProgram shaderProgram) {
    shaderProgram.uniforms.forEach((name, uniform) {
      if (!ignoreUniforms.contains(name)) {
        _setActiveUniform(name, uniform);
        _bindUniform(shaderProgram, name, uniform);
      }
    });
  }

  /// Check is uniform was changed or not.
  /// Return [true] if it was changed.
  bool _shouldBindUniform(String name) {
    return prevUniforms[name] != nextUniforms[name];
  }

  /// Set current active uniform.
  void _setActiveUniform(String name, Uniform uniform) {
    prevUniforms[name] = nextUniforms[name];
    nextUniforms[name] = uniform;
  }

  /// Bind uniform to shader program.
  void _bindUniform(ShaderProgram shaderProgram, String name, Uniform uniform) {
    webGL.Program glProgram = shaderProgram.glProgram;
    bool shouldBindUniform = _shouldBindUniform(name);

    if (!shouldBindUniform && uniform.state == QualifierState.CACHED) {
      return;
    }

    if (uniform.location == null) {
      uniform.location = _gl.getUniformLocation(glProgram, name);
    }

    webGL.UniformLocation uniformLocation = uniform.location;

    List uniformStorage = uniform.storage;

    switch (uniform.type) {
      case QualifierType.Bool1:
        if (uniform.useArray) {
          _gl.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Int1:
        if (uniform.useArray) {
          uniformStorage = new Int32List.fromList(uniformStorage);
          _gl.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Int2:
        if (uniform.useArray) {
          _gl.uniform2iv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform2i(uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case QualifierType.Int3:
        if (uniform.useArray) {
          _gl.uniform3iv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform3i(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case QualifierType.Int4:
        if (uniform.useArray) {
          _gl.uniform4iv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform4i(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case QualifierType.Float1:
        if (uniform.useArray) {
          _gl.uniform1fv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform1f(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Float2:
        if (uniform.useArray) {
          _gl.uniform2fv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform2f(uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case QualifierType.Float3:
        if (uniform.useArray) {
          _gl.uniform3fv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform3f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case QualifierType.Float4:
        if (uniform.useArray) {
          _gl.uniform4fv(uniformLocation, uniformStorage);
          break;
        }
        _gl.uniform4f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case QualifierType.Mat2:
          _gl.uniformMatrix2fv(uniformLocation, false, uniformStorage);
        break;
      case QualifierType.Mat3:
        _gl.uniformMatrix3fv(uniformLocation, false, uniformStorage);
        break;
      default:
        ;
    }
  }
}
