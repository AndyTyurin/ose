part of ose;

abstract class GameObject {
  /// Transformation.
  Transform transform;

  bool _isRenderable;

  GameObject() {
    this.transform = new Transform();
  }

  bool get isRenderable => _isRenderable;
}
