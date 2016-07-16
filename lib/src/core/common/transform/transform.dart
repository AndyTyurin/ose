part of ose;

abstract class Transform {
  /// Position.
  ///
  /// Note: Do not set [position.x], [position.y] manually,
  /// use [translateTo] or [translateBy] instead.
  Vector2 _position;

  /// Rotation.
  ///
  /// Note: Do not set [rotation.x], [rotation.y] manually,
  /// use [rotateTo] or [rotateBy] instead.
  Vector2 _rotation;

  /// Radians describes a rotation angle.
  double _radians;

  /// Rotation matirx.
  Matrix3 _rotationMatrix;

  /// Translation matrix.
  Matrix3 _translationMatrix;

  /// Create new transformation.
  Transform({Vector2 position, Vector2 rotation})
      : this._position = position ?? new Vector2(0.0, 0.0),
        this._rotation = rotation ?? new Vector2(0.0, 1.0) {
    this._radians = utils.getRadiansFromVector(this._rotation, Vector2.Y_AXIS);
    this._rotationMatrix = utils.setRotationMatrixFromRadians(this._radians);
    this._translationMatrix =
        utils.setTranslationMatrix(this._position.x, this._position.y);
  }

  /// Rotate by [radians].
  @mustCallSuper
  void rotateBy(double radians) {
    this._radians += radians;
    this._rotationMatrix = utils.setRotationMatrixFromRadians(this._radians);
    this._rotation.x = this._rotationMatrix.m00;
    this._rotation.y = this._rotationMatrix.m10;
  }

  /// Rotate to [rx], [ry].
  @mustCallSuper
  void rotateTo(double rx, double ry) {
    this._radians =
        utils.getRadiansFromVector(new Vector2(rx, ry), Vector2.Y_AXIS);
    this._rotationMatrix = utils.setRotationMatrixFromRadians(this._radians);
    this._rotation.x = this._rotationMatrix.m00;
    this._rotation.y = this._rotationMatrix.m10;
  }

  /// Translate by [tx], [ty].
  @mustCallSuper
  void translateBy(double tx, [double ty]) {
    this._position.x += tx;
    if (ty != null) {
      this._position.y += ty;
    }
    this._translationMatrix =
        utils.setTranslationMatrix(this._position.x, this._position.y);
  }

  /// Translate to [tx], [ty].
  @mustCallSuper
  void translateTo(double tx, double ty) {
    this._position.x = tx;
    this._position.y = ty;
    this._translationMatrix = utils.setTranslationMatrix(tx, ty);
  }

  set position(Vector2 position) {
    this.translateTo(position.x, position.y);
  }

  set rotation(Vector2 rotation) {
    this.rotateTo(rotation.x, rotation.y);
  }

  double get radians => this._radians;

  /// Note: Do not mutate vector.
  Vector2 get position => this._position;

  /// Note: Do not mutate vector.
  Vector2 get rotation => this._rotation;

  /// Note: Do not mutate matrix.
  Matrix3 get rotationMatrix => this._rotationMatrix;

  /// Note: Do not mutate matrix.
  Matrix3 get translationMatrix => this._translationMatrix;
}
