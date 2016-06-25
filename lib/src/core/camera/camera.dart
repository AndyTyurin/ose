part of ose;

class Camera {
  /// Unique id.
  String _uuid;

  /// Projection matrix.
  Matrix3 _projectionMatrix;

  /// Camera width.
  double _width;

  /// Camera height.
  double _height;

  /// Camera scale (zoom).
  double _scale;

  /// Create a new camera.
  Camera(this._width, this._height, [this._scale = 1.0]) {
    _uuid = utils.generateUuid();
    updateProjectionMatrix();
  }

  /// Update projection matrix.
  updateProjectionMatrix() {
    _projectionMatrix = utils.setProjectionMatrix(_width, _height, _scale);
  }

  Matrix3 get projectionMatrix => _projectionMatrix;
}
