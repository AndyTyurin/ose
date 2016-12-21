part of ose;

abstract class SceneObject extends Object with utils.UuidMixin {
  final SceneObjectTransform transform;

  Float32List _glVertices;

  Actor actor;

  final List<Filter> filters;

  SceneObject({SceneObjectTransform transform, Float32List vertices})
      : transform = transform ?? new SceneObjectTransform(),
        filters = <Filter>[] {
    _glVertices = vertices;
  }

  void update(num dt);

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }

  Float32List get glVertices => _glVertices;
}
