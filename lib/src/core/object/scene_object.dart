part of ose;

abstract class SceneObject extends Object with utils.UuidMixin {
  final SceneObjectTransform transform;

  Filter filter;

  SceneObject({SceneObjectTransform transform})
      : transform = transform ?? new SceneObjectTransform();

  void copyFrom(SceneObject from) {
    transform.rotation = from.transform.rotation;
    transform.scale = from.transform.scale.clone();
    transform.position = from.transform.position.clone();
  }
}
