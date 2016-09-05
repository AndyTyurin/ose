part of ose;

abstract class Transform {
  static Vector2 defaultPosition = new Vector2(0.0, 0.0);

  Vector2 position;

  double rotation;

  Matrix3 _translationMatrix;

  Matrix3 _rotationMatrix;

  Vector2 _prevPosition;

  double _prevRotation;

  /// Create new transformation.
  /// [position] - position vector.
  /// [rotation] - rotation vector.
  Transform({Vector2 position, double rotation}) {
    this.position = position ?? defaultPosition.clone();
    this.rotation = rotation ?? .0;
    _translationMatrix = new Matrix3.identity();
    _rotationMatrix = new Matrix3.identity();
  }

  void updateTranslationMatrix([bool force]) {
    if (force || isPositionChanged) {
      _translationMatrix = new Matrix3.translationFromVector(position);
    }
  }

  void updateRotationMatrix([bool force]) {
    if (force || isRotationChanged) {
      _rotationMatrix = new Matrix3.rotationFromAngle(rotation);
    }
  }

  @mustCallSuper
  @protected
  void _updatePrevValues() {
    _prevPosition = position.clone();
    _prevRotation = rotation;
  }

  Matrix3 get translationMatrix => _translationMatrix;

  Matrix3 get rotationMatrix => _rotationMatrix;

  bool get isPositionChanged => position != _prevPosition;

  bool get isRotationChanged => rotation != _prevRotation;
}
