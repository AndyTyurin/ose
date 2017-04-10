part of ose;

abstract class SceneObject extends RenderableObject
    implements ShaderDataProvider {
  final SceneObjectTransform transform;

  SceneObjectGroup parent;

  Actor actor;

  SceneObject({SceneObjectTransform transform})
      : transform = transform ?? new SceneObjectTransform();

  @override
  void update(num dt) {
    transform.updateModelMatrix();
  }

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }
}
