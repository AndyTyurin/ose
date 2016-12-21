part of ose;

/// Camera transformation has information about camera position, rotation, scale,
/// width & height parameters.
/// It has projection & view matrix.
class CameraTransform extends Transform {
  /// Projection matrix.
  Matrix3 _projectionMatrix;

  /// View matrix.
  Matrix3 _viewMatrix;

  /// Camera width.
  int _width;

  /// Camera height.
  int _height;

  /// Scale factor,
  /// where 2.0 is double-scale, 1.0 is normal scale.
  double _scale;

  /// Is project values has been changed.
  bool _isProjectionValuesChanged;

  /// Create a new camera transformation, where
  CameraTransform(this._width, this._height,
      {Vector2 position, double rotation, double scale})
      : super(position: position, rotation: rotation),
        _scale = scale ?? 1.0 {
    updateProjectionMatrix(true);
    updateViewMatrix(true);
  }

  /// Update projection matrix.
  void updateProjectionMatrix([bool force]) {
    if (force || shouldUpdateProjectionMatrix) {
      _projectionMatrix = new Matrix3.projection(_width, _height, _scale);
      _isProjectionValuesChanged = false;
      _updatePrevValues();
    }
  }

  /// Update view matrix.
  void updateViewMatrix([bool force]) {
    if (force || shouldUpdateViewMatrix) {
      updateTranslationMatrix(force);
      updateRotationMatrix(force);
      _viewMatrix = rotationMatrix * translationMatrix;
    }
  }

  set width(int width) {
    if (_width != width) {
      _width = width;
      _isProjectionValuesChanged = true;
    }
  }

  set height(int height) {
    if (_height != height) {
      _height = height;
      _isProjectionValuesChanged = true;
    }
  }

  set scale(double scale) {
    if (_scale != scale) {
      _scale = scale;
      _isProjectionValuesChanged = true;
    }
  }

  @override
  void copyFrom(CameraTransform transform) {
    super.copyFrom(transform);
    _width = transform.width;
    _height = transform.height;
    _scale = transform.scale;
    _projectionMatrix = transform.projectionMatrix.clone();
  }

  CameraTransform clone() {
    return new CameraTransform(width, height)..copyFrom(this);
  }

  Matrix3 get projectionMatrix => _projectionMatrix;

  Matrix3 get viewMatrix => _viewMatrix;

  bool get shouldUpdateProjectionMatrix =>
      isPositionChanged || isRotationChanged || _isProjectionValuesChanged;

  bool get shouldUpdateViewMatrix => isPositionChanged || isRotationChanged;

  int get width => _width;

  int get height => _height;

  double get scale => _scale;
}
