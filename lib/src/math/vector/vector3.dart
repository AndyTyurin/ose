part of ose_math;

class Vector3 extends Vector {
  /// World x axis.
  static Vector3 X_AXIS = new Vector3(1.0, 0.0, 0.0);

  /// World y axis.
  static Vector3 Y_AXIS = new Vector3(0.0, 1.0, 0.0);

  /// New vector with [x], [y], [z] elements.
  Vector3([double x = 0.0, double y = 0.0, double z = 0.0])
      : super(new Float32List.fromList([x, y, z]));

  /// Copy vector from [other].
  factory Vector3.copy(Vector3 other) => new Vector3(other.x, other.y, other.z);

  /// Scale vector by [factor].
  void scale(double factor) {
    x *= factor;
    y *= factor;
    z *= factor;
  }

  /// Add values of [v] to [this].
  void add(Vector3 v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  /// Subtract values of [v] from [this].
  void sub(Vector3 v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  /// Negate [this] vector.
  void negate() {
    x = -x;
    y = -y;
    z = -z;
  }

  /// Clone [this] vector.
  Vector3 clone() => new Vector3(x, y, z);

  /// Subtract [this] vector by [other].
  Vector3 operator -(Vector3 other) => clone()..sub(other);

  /// Negate [this] vector.
  Vector3 operator -() => clone()..negate();

  /// Add [this] vector by [other].
  Vector3 operator +(Vector3 other) => clone()..add(other);

  /// Multiply [this] vector by [scale].
  Vector3 operator *(double scale) => clone()..scale(scale);

  /// Divide [this] vector by [scale].
  Vector3 operator /(double scale) => clone()..scale(1 / scale);

  String toString() {
    return "Vector3: (${x}, ${y}, ${z})";
  }

  double get x => storage[0];

  double get y => storage[1];

  double get z => storage[2];

  Vector2 get xy => new Vector2(x, y);

  set x(double x) => storage[0] = x;

  set y(double y) => storage[1] = y;

  set z(double z) => storage[2] = z;
}
