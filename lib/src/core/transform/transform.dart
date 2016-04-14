import 'package:ose/src/math/math.dart';

class Transform {
  /// Local position relatives to parent.
  Vector2 _localPosition;

  /// Local rotation relatives to parent.
  Vector2 _localRotation;

  /// Local scale relatives to parent
  Vector2 _localScale;

  /// World position.
  ///
  /// Calculates from parent transform.
  Vector2 _position;

  /// World rotation.
  ///
  /// Calculates from parent transform.
  Vector2 _rotation;

  /// World scale.
  ///
  /// Calculates from parent transform.
  Vector2 _scale;

  /// Look at vector (aka forward).
  Vector2 lookAt;

  /// Parent transform.
  Transform _parent;

  Transform() {
    _localPosition = new Vector2();
    _localRotation = new Vector2();
    _localScale = new Vector2(1.0, 1.0);
    lookAt = new Vector2()..x = 1.0;
  }

  /// Rotate by degrees.
  void rotate(double degrees) {
    _localRotation.rotate(degrees);
  }

  /// Rotate vector to angle relatives to axis.
  void rotateTo(double angle, [Vector2 axis]) {
    // todo: implement.
  }

  /// Translate by x,y.
  void translate(double x, double y) {
    _localPosition.translate(x, y);
  }

  /// Translate by x.
  void translateX(double x) {
    _localPosition.translateX(x);
  }

  /// Translate by y.
  void translateY(double y) {
    _localPosition.translateY(y);
  }

  /// Translates to x,y.
  void translateTo(double x, double y) {
    _localPosition.x = x;
    _localPosition.y = y;
  }

  /// Scale by factor.
  void scale(double factor) {
    _localScale.scale(factor);
  }

  /// Scale by x.
  void scaleX(double x) {
    _localScale.scaleX(x);
  }

  /// Scale by y.
  void scaleY(double y) {
    _localScale.scaleY(y);
  }

  /// Scale to x,y.
  void scaleTo(double x, double y) {
    _localScale.x = x;
    _localScale.y = y;
  }

  /// Transform local values by transform.
  ///
  /// By using parent's transform re-calculate all local values
  /// to be relative to parent.
  void _transformLocalValues(Transform transform) {
    // todo: implement
  }

  Vector2 get localPosition => _localPosition;

  void set localPosition(Vector2 position) {
    // todo: change global position
    _localPosition = position;
  }

  Vector2 get localRotation => _localRotation;

  void set localRotation(Vector2 rotation) {
    // todo: change global rotation.
    _localRotation = rotation;
  }

  Vector2 get localScale => _localScale;

  void set localScale(Vector2 scale) {
    // todo: change global scale.
    _localScale = scale;
  }

  Vector2 get position => _position;

  void set position(Vector2 position) {
    // todo: change local position.
    _position = position;
  }

  Vector2 get rotation => _rotation;

  void set rotation(Vector2 rotation) {
    // todo: change local rotation.
    _rotation = rotation;
  }

  Vector2 get globalScale => _scale;

  void set globalScale(Vector2 scale) {
    // todo: change local scale.
    _scale = scale;
  }

  Transform get parent => _parent;

  void set parent(Transform transform) {
    _parent = parent;
    _transformLocalValues(transform);
  }
}
