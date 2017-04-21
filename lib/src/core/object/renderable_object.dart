part of ose;

abstract class RenderableObject extends SceneObject
    implements ShaderDataProvider {
  RenderableObjectGroup parent;

  /// WebGL vertices.
  Float32List _glVertices;

  RenderableObject(this._glVertices);

  Float32List get glVertices => _glVertices;

  SceneObjectActor get actor => actor;
}
