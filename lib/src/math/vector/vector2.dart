part of ose_math;

/// 2D column vector.
class Vector2 extends Vector {
  /// World x axis.
  static Vector2 X_AXIS = new Vector2(1.0, 0.0);

  /// World y axis.
  static Vector2 Y_AXIS = new Vector2(0.0, 1.0);

  /// Negative world y axis.
  static Vector2 NEG_Y_AXIS = Y_AXIS.clone()..negate();

  /// New vector with [x], [y] elements.
  Vector2([double x = 0.0, double y = 0.0])
      : super(new Float32List.fromList([x, y]));

  /// Copy vector from [other].
  factory Vector2.copy(Vector2 other) => new Vector2(other.x, other.y);

  /// Scale vector by [factor].
  void scale(double factor) {
    x *= factor;
    y *= factor;
  }

  /// Multiply [this] to [v].
  double multiply(Vector2 v) {
    return x * v.x + y * v.y;
  }

  /// Add values of [v] to [this].
  void add(Vector2 v) {
    x += v.x;
    y += v.y;
  }

  /// Subtract values of [v] from [this].
  void sub(Vector2 v) {
    x -= v.x;
    y -= v.y;
  }

  /// Negate [this] vector.
  void negate() {
    x = -x;
    y = -y;
  }

  /// Normalize [this] vector.
  void normalize() {
    var l = length();
    x /= l;
    y /= l;
  }

  /// Get vector length.
  double length() {
    return math.sqrt((x * x) + (y * y));
  }

  /// Clone [this] vector.
  Vector2 clone() => new Vector2(x, y);

  /// Subtract [this] vector by [other].
  Vector2 operator -(Vector2 other) => clone()..sub(other);

  /// Negate [this] vector.
  Vector2 operator -() => clone()..negate();

  /// Add [this] vector by [other].
  Vector2 operator +(Vector2 other) => clone()..add(other);

  /// Multiply [this] by value.
  ///
  /// Value can be [Vector2] or [double].
  /// Returns [Vector2] or [double] relatives to passed arguments.
  operator *(value) {
    if (value is Vector2) {
      return clone().multiply(value);
    }
    if (value is double) {
      return clone()..scale(value);
    }
    throw new ArgumentError(value);
  }

  /// Divide [this] vector by [scale].
  Vector2 operator /(double scale) => clone()..scale(1 / scale);

  String toString() {
    return "Vector2: (${x}, ${y})";
  }

  double get x => storage[0];

  double get y => storage[1];

  set x(double x) => storage[0] = x;

  set y(double y) => storage[1] = y;
}
