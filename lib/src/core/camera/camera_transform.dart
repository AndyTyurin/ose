part of ose;

class CameraTransform extends Transform {
  /// Projection matrix.
  Matrix3 _projectionMatrix;

  // Display width.
  int _width;

  // Display height.
  int _height;

  // Dimension scaling factor.
  double _scale;

  bool _isProjectionValuesChanged;

  CameraTransform(this._width, this._height,
      {Vector2 position, double rotation, double scale})
      : super(position: position, rotation: rotation),
        _scale = scale ?? 1.0 {
    updateProjectionMatrix(true);
  }

  /// Update projection matrix.
  void updateProjectionMatrix([bool forceUpdate]) {
    if (forceUpdate || shouldUpdateProjectionMatrix) {
      _projectionMatrix = new Matrix3.projection(_width, _height, _scale);
      _isProjectionValuesChanged = false;
      _updateVectors();
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

  Matrix3 get projectionMatrix => _projectionMatrix;

  bool get shouldUpdateProjectionMatrix =>
      isPositionChanged ||
      isRotationChanged ||
      _isProjectionValuesChanged;

  int get width => _width;

  int get height => _height;

  double get scale => _scale;
}
