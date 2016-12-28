part of ose;

abstract class SceneObject extends Object with utils.UuidMixin {
  final SceneObjectTransform transform;

  SceneObjectGroup parent;

  Actor actor;

  final List<Filter> filters;

  SceneObject({SceneObjectTransform transform})
      : transform = transform ?? new SceneObjectTransform(),
        filters = <Filter>[];

  void update(num dt);

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }
}
