part of ose;

class SceneObjectTransform extends Transform {
  static Vector2 defaultScale = new Vector2(1.0, 1.0);

  Vector2 scale;

  Vector2 _oldScale;

  Matrix3 _scaleMatrix;

  Matrix3 _modelMatrix;

  SceneObjectTransform({Vector2 position, Vector2 scale, double rotation})
      : super(position: position, rotation: rotation) {
    this.scale = scale ?? defaultScale.clone();
    updateModelMatrix(true);
  }

  void updateModelMatrix([bool force]) {
    if (force || shouldUpdateModelMatrix) {
      updateScaleMatrix(force);
      updateRotationMatrix(force);
      updateTranslationMatrix(force);
      _modelMatrix = scaleMatrix * rotationMatrix * translationMatrix;
      _updatePrevValues();
    }
  }

  void updateScaleMatrix([bool force]) {
    if (force || isScaleChanged) {
      _scaleMatrix = new Matrix3.scaleFromVector(scale);
    }
  }

  @override
  void _updatePrevValues() {
    super._updatePrevValues();
    _oldScale = scale.clone();
  }

  @override
  void copyFrom(SceneObjectTransform transform) {
    super.copyFrom(transform);
    scale = transform.scale.clone();
    _scaleMatrix = transform.scaleMatrix.clone();
    _modelMatrix = transform.modelMatrix.clone();
    _updatePrevValues();
    updateModelMatrix(true);
  }

  SceneObjectTransform clone() {
    return new SceneObjectTransform()..copyFrom(this);
  }

  Matrix3 get scaleMatrix => _scaleMatrix;

  Matrix3 get modelMatrix => _modelMatrix;

  bool get isScaleChanged => scale != _oldScale;

  bool get shouldUpdateModelMatrix =>
      isPositionChanged || isRotationChanged || isScaleChanged;
}
