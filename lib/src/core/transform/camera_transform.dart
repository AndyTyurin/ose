part of ose;

class CameraTransform extends Transform {
  Matrix3 _projectionMatrix;

  int _width;

  int _height;

  double _scale;

  bool _isProjectionValuesChanged;

  CameraTransform(this._width, this._height,
      {Vector2 position, double rotation, double scale})
      : super(position: position, rotation: rotation),
        _scale = scale ?? 1.0 {
    updateProjectionMatrix(true);
  }

  /// Update projection matrix.
  void updateProjectionMatrix([bool force]) {
    if (force || shouldUpdateProjectionMatrix) {
      // todo: Add
      _projectionMatrix = new Matrix3.projection(_width, _height, _scale);
      _isProjectionValuesChanged = false;
      _updatePrevValues();
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

  bool get shouldUpdateProjectionMatrix =>
      isPositionChanged || isRotationChanged || _isProjectionValuesChanged;

  int get width => _width;

  int get height => _height;

  double get scale => _scale;
}
