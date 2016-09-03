part of ose_webgl;

class ShapeFilter extends Filter {
  ShapeFilter() : super(shapeShaderProgram);

  /// See [Filter.apply].
  void apply(ose.GameObject obj, ose.Scene scene, ose.Camera camera) {
    if (obj is Shape) {
      shaderProgram.attributes['a_color'].update(obj.glColors);
    }
    super.apply(obj, scene, camera);
  }
}
