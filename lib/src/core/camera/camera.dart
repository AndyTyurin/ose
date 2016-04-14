import 'package:vector_math/vector_math.dart';

import 'package:ose/src/utils/uuid.dart';

class Camera {
  /// Unique id.
  String _uuid;

  /// View transformation matrix.
  Matrix4 _transform;

  /// Left clipping plane.
  double _left;

  /// Right clipping plane.
  double _right;

  /// Bottom clipping plane.
  double _bottom;

  /// Top clipping plane.
  double _top;

  /// Near clipping plane.
  double _near;

  /// Far clipping plane.
  double _far;

  /// Create a new camera.
  ///
  /// Use [CameraManager] to create a new [Camera].
  Camera(this._left, this._right, this._bottom, this._top,
      this._near, this._far) {
    _uuid = generateUuid();
    _rebuildCamera();
  }

  /// Re-build camera.
  ///
  /// Mainly used when one of the params was changed.
  Matrix4 _rebuildCamera() {
    return _transform =
        makeOrthographicMatrix(_left, _right, _bottom, _top, _near, _far);
  }

  String get uuid => _uuid;

  double get left => _left;

  void set left(double left) {
    _left = left;
    _rebuildCamera();
  }

  double get right => _right;

  void set right(double right) {
    _right = right;
    _rebuildCamera();
  }

  double get bottom => _bottom;

  void set bottom(double bottom) {
    _bottom = bottom;
    _rebuildCamera();
  }

  double get top => _top;

  void set top(double top) {
    _top = top;
    _rebuildCamera();
  }

  double get near => _near;

  void set near(double near) {
    _near = near;
    _rebuildCamera();
  }

  double get far => _far;

  void set far(double far) {
    _far = far;
    _rebuildCamera();
  }

  Matrix4 get transform => _transform;
}
