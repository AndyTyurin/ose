part of ose;

/// [GameObjectTransform] manages position, rotation, scaling values.
/// It could be used by [GameObject] to set up transformation in 2D space.
/// Basic transformations can be done by using of translation, rotation or
/// scaling.
/// Prefer to use methods instead of direct change of the vectors, because
/// renderer checks [shouldUpdateModelMatrix] and if it [true], updates
/// the model matrix.
class GameObjectTransform extends Transform {
  /// Scale vector.
  Vector2 _scale;

  Vector2 _oldScale;

  /// Model matrix.
  Matrix3 _modelMatrix;

  /// Create new transformation.
  GameObjectTransform({Vector2 position, Vector2 scale, num rotation})
      : super(position: position, rotation: rotation) {
    _scale = scale ?? new Vector2(1.0, 1.0);
    updateModelMatrix(true);
  }

  /// Update model matrix.
  /// Multiply scale, rotation and translation matrices.
  void updateModelMatrix([bool forceUpdate]) {
    if (forceUpdate || shouldUpdateModelMatrix) {
      _modelMatrix = scaleMatrix * rotationMatrix * translationMatrix;
      _updateVectors();
    }
  }

  @override
  void _updateVectors() {
    super._updateVectors();
    _oldScale = _scale;
  }

  Vector2 get scale => _scale;

  set scale(Vector2 scale) {
    _scale = scale;
  }

  Matrix3 get scaleMatrix => new Matrix3.scaleFromVector(_scale);

  Matrix3 get modelMatrix => _modelMatrix;

  bool get isScaleChanged => _scale != _oldScale;

  bool get shouldUpdateModelMatrix =>
      isPositionChanged ||
      isRotationChanged ||
      isScaleChanged;
}
