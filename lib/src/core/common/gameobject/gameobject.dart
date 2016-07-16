part of ose;

abstract class GameObject {
  /// Unique id.
  String _uuid;

  /// Is renderable.
  bool _isRenderable;

  /// Transformation.
  GameObjectTransform _transform;

  GameObject({Vector2 position, Vector2 rotation, Vector2 scale})
      : this._transform = new GameObjectTransform(
            position: position, rotation: rotation, scale: scale),
        this._isRenderable = true,
        this._uuid = utils.generateUuid();

  bool get isRenderable => this._isRenderable;

  GameObjectTransform get transform => this._transform;
}
