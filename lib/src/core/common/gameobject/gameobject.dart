part of ose;

/// [GameObject] is entity used by renderer to display it.
/// Each game object is unique, has his own transformation and should be
/// implemented by other, specific entity.
abstract class GameObject {
  /// Unique id.
  final String uuid;

  /// Transformation.
  GameObjectTransform transform;

  /// Create a new game object.
  /// [transform] - game object's transformation.
  GameObject({GameObjectTransform transform}) : uuid = utils.generateUuid() {
    this.transform = transform ?? new GameObjectTransform();
  }

  void copyFrom(GameObject from) {
    transform = new GameObjectTransform(
        position: from.transform.position,
        rotation: from.transform.rotation,
        scale: from.transform.scale);
  }
}
