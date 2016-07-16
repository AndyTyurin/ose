part of ose;

class CameraTransform extends Transform {
  /// Projection matrix.
  Matrix3 _projectionMatrix;

  // Display width.
  int _width;

  // Display height.
  int _height;

  // Dimension scaling factor.
  num _scale;

  /// Should update projection matrix.
  bool _shouldUpdateProjectionMatrix;

  CameraTransform(this._width, this._height,
      {Vector2 position, Vector2 rotation, num scale})
      : super(position: position, rotation: rotation),
        this._scale = scale ?? 1.0 {
    this.updateProjectionMatrix();
  }

  /// Update projection matrix.
  void updateProjectionMatrix() {
    this._projectionMatrix =
        utils.setProjectionMatrix(this._width, this._height, this._scale) *
            this._rotationMatrix *
            this._translationMatrix;
    this._shouldUpdateProjectionMatrix = false;
    ;
  }

  /// Rotate by [radians].
  @override
  void rotateBy(double radians) {
    super.rotateBy(radians);
    this._shouldUpdateProjectionMatrix = true;
  }

  /// Rotate to [rx], [ry].
  @override
  void rotateTo(double rx, double ry) {
    super.rotateTo(rx, ry);
    this._shouldUpdateProjectionMatrix = true;
  }

  /// Translate by [tx], [ty].
  @override
  void translateBy(double tx, [double ty]) {
    super.translateBy(tx, ty);
    this._shouldUpdateProjectionMatrix = true;
  }

  /// Translate to [tx], [ty].
  @override
  void translateTo(double tx, double ty) {
    super.translateTo(tx, ty);
    this._shouldUpdateProjectionMatrix = false;
  }

  /// Scale by [scale].
  void scaleBy(num scale) {
    this.scale = this._scale + scale;
  }

  /// Scale to [scale].
  void scaleTo(num scale) {
    this.scale = scale;
  }

  set width(int width) {
    this._width = width;
    this._shouldUpdateProjectionMatrix = true;
  }

  set height(int height) {
    this._height = height;
    this._shouldUpdateProjectionMatrix = true;
  }

  set scale(int scale) {
    this._scale = scale;
    this._shouldUpdateProjectionMatrix = true;
  }

  /// Note: Do not mutate matrix.
  Matrix3 get projectionMatrix => this._projectionMatrix;

  bool get shouldUpdateProjectionMatrix => this._shouldUpdateProjectionMatrix;

  int get width => this._width;

  int get height => this._height;

  num get scale => this._scale;
}
