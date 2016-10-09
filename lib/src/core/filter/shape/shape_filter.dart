part of ose;

class ShapeFilter extends Filter {
  ShapeFilter() : super(shapeShaderProgram) {
    attributes.addAll({
      'a_color': new Attribute.FloatArray4()
    });
    uniforms.addAll({
      'u_model': new Uniform.Mat3(),
      'u_projection': new Uniform.Mat3()
    });
  }

  /// See [Filter.apply].
  void apply(SceneObject obj, Scene scene, Camera camera) {
    if (obj is Shape) {
      attributes['a_color'].update(obj.glColors);
    }
    super.apply(obj, scene, camera);
  }
}
