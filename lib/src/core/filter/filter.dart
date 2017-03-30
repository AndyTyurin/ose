part of ose;

/// Filter controls your shader program.
/// Each renderer tick [Filter.update] updates shader program's
/// attributes & uniforms values.
abstract class Filter extends Object with utils.UuidMixin {
  final ShaderProgram shaderProgram;

  final Set<ShaderProgram> shaderPrograms;

  Filter(): shaderPrograms = new Set<ShaderProgram>(shaderPrograms) {
    attributes.addAll({
      'a_position': new Attribute.FloatArray2()..location = 0,
    });
    uniforms.addAll({
      'u_p': new Uniform.Mat3(),
      'u_m': new Uniform.Mat3(),
      'u_v': new Uniform.Mat3()
    });
  }

  /// Apply filter by updating attributes and uniforms by using of filter manager.
  void apply(FilterManager filterManager, SceneObject obj, Scene scene,
      Camera camera) {
    if ((obj as dynamic).glVertices != null) {
      filterManager
          .updateAttributes({'a_position': (obj as dynamic).glVertices});
    }

    Matrix3 modelMatrix = obj.transform.modelMatrix;

    if (obj.parent != null) {
      modelMatrix *= obj.parent.transform.modelMatrix;
    }

    filterManager.updateUniforms({
      'u_p': camera.transform.projectionMatrix,
      'u_m': modelMatrix,
      'u_v': camera.transform.viewMatrix
    });
  }

  bool operator ==(Filter other) => this.uuid == other.uuid;

  Map<String, Attribute> get attributes => shaderProgram.attributes;

  Map<String, Uniform> get uniforms => shaderProgram.uniforms;
}
