part of ose;

class ShapeFilter extends Filter {
  ShapeFilter() : super(shapeShaderProgram);

  /// See [Filter.apply].
  void apply(SceneObject obj, Scene scene, Camera camera) {
    if (obj is Shape) {
      shaderProgram.attributes['a_color'].update(obj.glColors);
    }
    super.apply(obj, scene, camera);
  }
}
