part of ose_webgl;

// TODO: Re-factor filter.

abstract class Filter extends ose.Filter {
  /// Shader program.
  ShaderProgram _shaderProgram;

  /// Position attribute.
  Attribute _aPosition;

  /// Projection uniform.
  Uniform _uProjection;

  /// Model uniform.
  Uniform _uModel;

  Filter(this._shaderProgram) {
    this._uProjection = new Uniform.Mat3();
    this._uModel = new Uniform.Mat3();
    this._aPosition = new Attribute.FloatArray2();
    this.addUniforms(
        {'u_projection': this._uProjection, 'u_model': this._uModel});
    this.addAttributes({'a_position': this._aPosition});
  }

  /// Add uniforms to shader program.
  void addUniforms(Map<String, Uniform> uniforms) {
    this._shaderProgram.uniforms.addAll(uniforms);
  }

  /// Add attributes to shader program.
  void addAttributes(Map<String, Attribute> attributes) {
    this._shaderProgram.attributes.addAll(attributes);
  }

  /// See [ose.Filter].
  void apply(ose.GameObject obj, ose.Scene scene, ose.Camera camera) {
    if (obj is ose.Primitive) {
      this._aPosition.update(obj.vertices);
      this._uModel.update(obj.transform.modelMatrix);
    }

    this._uProjection.update(camera.transform.projectionMatrix);

    this._shaderProgram.use();
    this._shaderProgram.applyAttributes();
    this._shaderProgram.applyUniforms();
  }

  ShaderProgram get shaderProgram => _shaderProgram;

  Attribute get aPosition => _aPosition;

  Uniform get uProjection => _uProjection;

  Uniform get uModel => _uModel;
}
