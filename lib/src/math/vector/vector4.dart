part of ose_math;

// TODO: Cloned from Vector3 - must be implemented.

class Vector4 extends Vector {
  /// World x axis.
  static Vector4 X_AXIS = new Vector4(1.0, 0.0, 0.0);

  /// World y axis.
  static Vector4 Y_AXIS = new Vector4(0.0, 1.0, 0.0);

  /// New vector with [x], [y], [z] elements.
  Vector4([double x = 0.0, double y = 0.0, double z = 0.0, double w = 0.0])
      : super(new Float32List.fromList([x, y, z, w]));

  /// Copy vector from [other].
  factory Vector4.copy(Vector4 other) =>
      new Vector4(other.x, other.y, other.z, other.w);

  /// Set vector values.
  void setValues(double x, double y, double z, double w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }

  /// Scale vector by [factor].
  void scale(double factor) {
    x *= factor;
    y *= factor;
    z *= factor;
    w *= factor;
  }

  /// To make [this] values absolute.
  void absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    w = w.abs();
  }

  /// Add values of [v] to [this].
  void add(Vector4 v) {
    x += v.x;
    y += v.y;
    z += v.z;
    w += v.w;
  }

  /// Subtract values of [v] from [this].
  void sub(Vector4 v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
    w -= v.w;
  }

  /// Negate [this] vector.
  void negate() {
    x = -x;
    y = -y;
    z = -z;
    w = -w;
  }

  /// Clone [this] vector.
  Vector4 clone() => new Vector4(x, y, z, w);

  /// Subtract [this] vector by [other].
  Vector4 operator -(Vector4 other) => clone()..sub(other);

  /// Negate [this] vector.
  Vector4 operator -() => clone()..negate();

  /// Add [this] vector by [other].
  Vector4 operator +(Vector4 other) => clone()..add(other);

  /// Multiply [this] vector by [scale].
  Vector4 operator *(double scale) => clone()..scale(scale);

  /// Divide [this] vector by [scale].
  Vector4 operator /(double scale) => clone()..scale(1 / scale);

  String toString() {
    return "Vector4: (${x}, ${y}, ${z}, ${w})";
  }

  double get x => storage[0];

  double get y => storage[1];

  double get z => storage[2];

  double get w => storage[3];

  Vector2 get xy => new Vector2(x, y);

  set x(double x) => storage[0] = x;

  set y(double y) => storage[1] = y;

  set z(double z) => storage[2] = z;

  set w(double w) => storage[3] = w;
}
