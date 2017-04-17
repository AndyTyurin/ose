part of ose;

abstract class SceneObject extends RenderableObject
    implements ShaderDataProvider {
  SceneObjectGroup parent;

  /// WebGL vertices.
  Float32List _glVertices;

  SceneObject(this._glVertices);

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }

  Float32List get glVertices => _glVertices;

  void set actor(SceneObjectActor actor) {
    _actor = actor;
  }

  SceneObjectActor get actor => _actor;
}
