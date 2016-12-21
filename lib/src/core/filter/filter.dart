part of ose;

/// Filter controls your shader program.
/// Each renderer tick [Filter.update] updates shader program's
/// attributes & uniforms values.
abstract class Filter extends Object with utils.UuidMixin {
  final ShaderProgram shaderProgram;

  Filter(this.shaderProgram) {
    attributes.addAll({
      'a_position': new Attribute.FloatArray2()..location = 0
    });
    uniforms.addAll({
      'u_model': new Uniform.Mat3(),
      'u_projection': new Uniform.Mat3(),
      'u_view': new Uniform.Mat3()
    });
  }

  /// Apply filter by updating attributes and uniforms by using of filter manager.
  void apply(FilterManager filterManager, SceneObject obj, Scene scene, Camera camera) {
    if ((obj as dynamic).glVertices != null) {
      filterManager.updateAttributes({
        'a_position': (obj as dynamic).glVertices
      });
    }

    filterManager.updateUniforms({
      'u_model': obj.transform.modelMatrix,
      'u_projection': camera.transform.projectionMatrix,
      'u_view': camera.transform.viewMatrix
    });
  }

  bool operator ==(Filter other) => this.uuid == other.uuid;

  Map<String, Attribute> get attributes => shaderProgram.attributes;

  Map<String, Uniform> get uniforms => shaderProgram.uniforms;
}
