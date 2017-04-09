part of ose;

abstract class SceneObject extends Object with utils.UuidMixin {
  final SceneObjectTransform transform;

  SceneObjectGroup parent;

  Actor actor;

  SceneObject({SceneObjectTransform transform})
      : transform = transform ?? new SceneObjectTransform();

  void update(num dt);

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }

  /// Implement to define specific vertex shader to use.
  String getVertexShaderSource();

  /// Implement to define specific fragment shader to use.
  String getFragmentShaderSource();

  /// Should use common shader definitions while registering in manager.
  /// If [true], Some attributes, uniforms and rules will be defined on
  /// top of your shaders' sources (vertex and fragment).
  bool shouldUseCommonShaderDefinitions() {
    return true;
  }
}
