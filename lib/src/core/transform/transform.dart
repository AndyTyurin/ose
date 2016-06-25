part of ose;

class Transform {
  /// Rotation matrix.
  Matrix3 _rotationMatrix;

  /// Translation matrix.
  Matrix3 _translationMatrix;

  /// Scale matrix.
  Matrix3 _scaleMatrix;

  /// Model matrix.
  Matrix3 _modelMatrix;

  /// Position.
  ///
  /// Note: Do not set [position.x], [position.y] manually,
  /// use [translateTo] or [translateBy] instead.
  Vector2 _position;

  /// Scale.
  ///
  /// Note: Do not set [scale.x], [scale.y] manually,
  /// use [scaleTo] or [scaleBy] instead.
  Vector2 _scale;

  /// Rotation.
  ///
  /// Note: Do not set [rotation.x], [rotation.y] manually,
  /// use [rotateTo] or [rotateBy] instead.
  Vector2 _rotation;

  double _radians;

  /// Should update model matrix.
  ///
  /// [true] if one of the calculation matrices was changed.
  bool _shouldUpdateModelMatrix;

  /// Create new transformation.
  Transform(
      {Vector2 position, Vector2 rotation, Vector2 scale, double degrees}) {
    _position = (position == null) ? new Vector2(0.0, 0.0) : position;
    _scale = (scale == null) ? new Vector2(1.0, 1.0) : scale;
    _rotation = (rotation == null) ? new Vector2(0.0, 1.0) : rotation;
    _radians = utils.getRadiansFromVector(_rotation, Vector2.Y_AXIS);
    _rotationMatrix = utils.setRotationMatrixFromRadians(_radians);
    _translationMatrix = utils.setTranslationMatrix(_position.x, _position.y);
    _scaleMatrix = utils.setScaleMatrix(_scale.x, _scale.y);
    _shouldUpdateModelMatrix = true;
    updateModelMatrix();
  }

  /// Rotate by [radians].
  void rotateBy(double radians) {
    _radians += radians;
    _rotationMatrix = utils.setRotationMatrixFromRadians(_radians);
    _rotation.x = _rotationMatrix.m00;
    _rotation.y = _rotationMatrix.m10;
    _shouldUpdateModelMatrix = true;
  }

  /// Rotate to [rx], [ry].
  void rotateTo(double rx, double ry) {
    _radians = utils.getRadiansFromVector(new Vector2(rx, ry), Vector2.Y_AXIS);
    _rotationMatrix = utils.setRotationMatrixFromRadians(_radians);
    _rotation.x = _rotationMatrix.m00;
    _rotation.y = _rotationMatrix.m10;
    _shouldUpdateModelMatrix = true;
  }

  /// Translate by [tx], [ty].
  void translateBy(double tx, [double ty]) {
    _position.x += tx;
    if (ty != null) {
      _position.y += ty;
    }
    _translationMatrix = utils.setTranslationMatrix(_position.x, _position.y);
    _shouldUpdateModelMatrix = true;
  }

  /// Translate to [tx], [ty].
  void translateTo(double tx, double ty) {
    _position.x = tx;
    _position.y = ty;
    _translationMatrix = utils.setTranslationMatrix(tx, ty);
    _shouldUpdateModelMatrix = true;
  }

  /// Scale by [sx], [sy].
  void scaleBy(double sx, [double sy]) {
    _scale.x += sx;
    if (sy != null) {
      _scale.y += sy;
    }
    _scaleMatrix = utils.setScaleMatrix(_scale.x, _scale.y);
    _shouldUpdateModelMatrix = true;
  }

  /// Scale to [sx], [sy].
  void scaleTo(double sx, double sy) {
    _scale.x = sx;
    _scale.y = sy;
    _scaleMatrix = utils.setScaleMatrix(sx, sy);
    _shouldUpdateModelMatrix = true;
  }

  /// Update model matrix.
  ///
  /// Multiply scale, rotation and translation matrices.
  updateModelMatrix() {
    if (_shouldUpdateModelMatrix) {
      _modelMatrix = (_scaleMatrix * _rotationMatrix * _translationMatrix)..transpose();
      _shouldUpdateModelMatrix = false;
    }
  }

  Matrix3 get modelMatrix => _modelMatrix;

  Vector2 get scale => _scale..clone();

  Vector2 get position => _position..clone();

  Vector2 get rotation => _rotation..clone();

  set scale(Vector2 scale) {
    scaleTo(scale.x, scale.y);
  }

  set position(Vector2 position) {
    translateTo(position.x, position.y);
  }

  set rotation(Vector2 rotation) {
    rotateTo(rotation.x, rotation.y);
  }
}
