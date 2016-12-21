part of ose;

/// Basic filter is basic implementation of a [Filter],
/// used to handle [Shape] objects.
class BasicFilter extends Filter {
  BasicFilter() : super(basicShaderProgram) {
    attributes.addAll(basicShaderProgramAttributes);
  }

  /// See [Filter.apply].
  void apply(FilterManager filterManager, SceneObject obj, Scene scene,
      Camera camera) {
    if ((obj as dynamic).glColors != null) {
      filterManager.updateAttributes({'a_color': (obj as dynamic).glColors});
    }
    super.apply(filterManager, obj, scene, camera);
  }
}
