part of ose;

class GameObjectTransform extends Transform {
  /// Should update model matrix.
  ///
  /// [true] if one of the calculation matrices was changed.
  bool _shouldUpdateModelMatrix;

  /// Scale matrix.
  Matrix3 _scaleMatrix;

  /// Model matrix.
  Matrix3 _modelMatrix;

  /// Scale vector.
  ///
  /// Note: Do not set [scale.x], [scale.y] manually,
  /// use [scaleTo] or [scaleBy] instead.
  Vector2 _scale;

  /// Create new transformation.
  GameObjectTransform(
      {Vector2 position, Vector2 rotation, Vector2 scale})
      : super(position: position, rotation: rotation),
        this._scale = scale ?? new Vector2(1.0, 1.0),
        this._shouldUpdateModelMatrix = true {
    this._rotationMatrix = utils.setRotationMatrixFromRadians(this._radians);
    this._translationMatrix =
        utils.setTranslationMatrix(this._position.x, this._position.y);
    this._scaleMatrix = utils.setScaleMatrix(this._scale.x, this._scale.y);
    this.updateModelMatrix();
  }

  /// Rotate by [radians].
  @override
  void rotateBy(double radians) {
    this.rotateBy(radians);
    this._shouldUpdateModelMatrix = true;
  }

  /// Rotate to [rx], [ry].
  @override
  void rotateTo(double rx, double ry) {
    this.rotateTo(rx, ry);
    this._shouldUpdateModelMatrix = true;
  }

  /// Translate by [tx], [ty].
  @override
  void translateBy(double tx, [double ty]) {
    super.translateBy(tx, ty);
    this._shouldUpdateModelMatrix = true;
  }

  /// Translate to [tx], [ty].
  @override
  void translateTo(double tx, double ty) {
    super.translateTo(tx, ty);
    this._shouldUpdateModelMatrix = true;
  }

  /// Scale by [sx], [sy].
  void scaleBy(double sx, [double sy]) {
    this._scale.x += sx;
    if (sy != null) {
      this._scale.y += sy;
    }
    this._scaleMatrix = utils.setScaleMatrix(this._scale.x, this._scale.y);
    this._shouldUpdateModelMatrix = true;
  }

  /// Scale to [sx], [sy].
  void scaleTo(double sx, double sy) {
    this._scale.x = sx;
    this._scale.y = sy;
    this._scaleMatrix = utils.setScaleMatrix(sx, sy);
    this._shouldUpdateModelMatrix = true;
  }

  /// Update model matrix.
  ///
  /// Multiply scale, rotation and translation matrices.
  void updateModelMatrix() {
    this._modelMatrix = (this._scaleMatrix *
        this._rotationMatrix *
        this._translationMatrix)..transpose();
    this._shouldUpdateModelMatrix = false;
  }

  /// Note: Do not mutate vector.
  Vector2 get scale => this._scale;

  /// Note: Do not mutate matrix.
  Matrix3 get modelMatrix => this._modelMatrix;

  /// Note: Do not mutate matrix.
  Matrix3 get scaleMatrix => this._scaleMatrix;
}
