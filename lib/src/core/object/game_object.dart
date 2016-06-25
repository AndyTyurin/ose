part of ose;

abstract class GameObject {
  /// Transformation.
  Transform transform;

  GameObject() {
    this.transform = new Transform();
  }
}
