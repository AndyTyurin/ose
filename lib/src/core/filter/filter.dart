part of ose;

abstract class Filter {
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
    this.addUniforms({'u_projection': _uProjection, 'u_model': _uModel});
    this.addAttributes({'a_position': _aPosition});
  }

  /// Add uniforms to shader program.
  void addUniforms(Map<String, Uniform> uniforms) {
    this._shaderProgram.uniforms.addAll(uniforms);
  }

  /// Add attributes to shader program.
  void addAttributes(Map<String, Attribute> attributes) {
    this._shaderProgram.attributes.addAll(attributes);
  }

  /// Apply filter.
  ///
  /// Call shader program in use.
  void apply(Scene scene, GameObject obj) {
    _aPosition.update((obj as VerticesMixin).vertices);
    _uProjection.update(scene.camera.projectionMatrix);
    _uModel.update(obj.transform.modelMatrix);

    this._shaderProgram.use();
    this._shaderProgram.applyAttributes();
    this._shaderProgram.applyUniforms();
  }

  ShaderProgram get shaderProgram => _shaderProgram;

  Attribute get aPosition => _aPosition;

  Uniform get uProjection => _uProjection;

  Uniform get uModel => _uModel;
}
