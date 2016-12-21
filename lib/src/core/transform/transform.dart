part of ose;

/// Transformation holds information about object's position and rotation.
/// Basically it's needed to make matrix calculations, that are very important
/// in shaders.
abstract class Transform {
  static Vector2 defaultPosition = new Vector2(0.0, 0.0);

  /// Position.
  Vector2 position;

  /// Rotation.
  double rotation;

  /// Forward vector.
  Vector2 _forward;

  /// Translation matrix.
  Matrix3 _translationMatrix;

  /// Rotation matrix.
  Matrix3 _rotationMatrix;

  /// Previous position vector to track changes.
  Vector2 _prevPosition;

  /// Previous rotation vector to track changes.
  double _prevRotation;

  /// Create new transformation.
  /// [position] - position vector.
  /// [rotation] - value in radians.
  Transform({Vector2 position, double rotation}) {
    this.position = position ?? defaultPosition.clone();
    this.rotation = rotation ?? .0;
    _forward = new Vector2.zero();
    _translationMatrix = new Matrix3.identity();
    _rotationMatrix = new Matrix3.identity();
  }

  /// Update translation matrix on change.
  void updateTranslationMatrix([bool force = false]) {
    if (force || isPositionChanged) {
      _translationMatrix = new Matrix3.translationFromVector(position);
    }
  }

  /// Update rotation matrix on change.
  void updateRotationMatrix([bool force = false]) {
    if (force || isRotationChanged) {
      _rotationMatrix = new Matrix3.rotationFromAngle(rotation);
      _forward.x = _rotationMatrix.m10;
      _forward.y = _rotationMatrix.m00;
    }
  }

  @mustCallSuper
  @protected
  void _updatePrevValues() {
    _prevPosition = position.clone();
    _prevRotation = rotation;
  }

  void copyFrom(Transform transform) {
    position = transform.position.clone();
    rotation = transform.rotation;
    _translationMatrix = transform.translationMatrix;
    _rotationMatrix = transform.rotationMatrix;
    _updatePrevValues();
  }

  Matrix3 get translationMatrix => _translationMatrix;

  Matrix3 get rotationMatrix => _rotationMatrix;

  Vector2 get forward => _forward;

  bool get isPositionChanged => position != _prevPosition;

  bool get isRotationChanged => rotation != _prevRotation;
}
