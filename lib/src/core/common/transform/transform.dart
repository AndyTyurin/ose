part of ose;

/// [Transform] manages position & rotation in 2D space.
abstract class Transform {
  /// Position vector.
  Vector2 _position;

  Vector2 _oldPosition;

  bool _isRotationChanged;

  /// Rotation vector.
  double _rotation;

  /// Create new transformation.
  /// [position] - position vector.
  /// [rotation] - rotation vector.
  Transform({Vector2 position, double rotation}) {
    _position = position ?? new Vector2(0.0, 0.0);
    _rotation = 0.0;
  }

  void _updateVectors() {
    _oldPosition = position;
  }

  Matrix3 get translationMatrix => new Matrix3.translationFromVector(_position);

  Matrix3 get rotationMatrix => new Matrix3.rotationFromAngle(_rotation);

  Vector2 get position => _position;

  set position(Vector2 position) {
    _position = position;
  }

  double get rotation => _rotation;

  set rotation(double rotation) {
    if (_rotation != rotation) {
      _rotation = rotation;
      _isRotationChanged = true;
    }
  }

  bool get isPositionChanged => _position != _oldPosition;

  bool get isRotationChanged => _isRotationChanged;
}
