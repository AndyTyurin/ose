part of ose_math;

/// Matrix 2x2.
///
/// Values are in column major order.
class Matrix2 extends Matrix {
  /// New matrix.
  Matrix2() : super(new Float32List(4));

  /// New identity matrix.
  factory Matrix2.identity() => new Matrix2()..setIdentity();

  /// Copy matrix from [other].
  factory Matrix2.copy(Matrix2 other) => new Matrix2()..setFrom(other);

  /// New matrix from values list.
  factory Matrix2.fromList(List values) =>
      new Matrix2()..setValues(values[0], values[1], values[2], values[3]);

  /// New matrix from values.
  factory Matrix2.fromValues(double m00, double m01, double m10, double m11) =>
      new Matrix2()..setValues(m00, m01, m10, m11);

  /// Makes [this] as identity matrix.
  void setIdentity() {
    m00 = 1.0;
    m01 = 0.0;
    m10 = 1.0;
    m11 = 0.0;
  }

  /// Apply values from [other] matrix.
  void setFrom(Matrix2 other) {
    m00 = other.m00;
    m01 = other.m01;
    m10 = other.m10;
    m11 = other.m11;
  }

  /// Set specific values.
  void setValues(double m00, double m01, double m10, double m11) {
    this.m00 = m00;
    this.m01 = m01;
    this.m10 = m10;
    this.m11 = m11;
  }

  /// Negate [this] matrix.
  void negate() {
    m00 = -m00;
    m10 = -m10;
    m01 = -m01;
    m11 = -m11;
  }

  /// Transpose [this] matrix.
  void transpose() {
    final n01 = m01;
    m01 = m10;
    m10 = n01;
  }

  /// Clone [this] to new one.
  Matrix2 clone() => new Matrix2.copy(this);

  /// Multiply [this] by [m].
  void multiply(Matrix2 m) {
    final n00 = m00;
    final n01 = m01;
    final n10 = m10;
    final n11 = m11;
    final j00 = m.m00;
    final j01 = m.m01;
    final j10 = m.m10;
    final j11 = m.m11;
    m00 = (n00 * j00) + (n01 * j10);
    m01 = (n10 * j00) + (n11 * j10);
    m10 = (n00 * j01) + (n01 * j11);
    m11 = (n10 * j01) + (n11 * j11);
  }

  /// Scale [this] by [factor]
  void scale(double factor) {
    m00 *= factor;
    m01 *= factor;
    m10 *= factor;
    m11 *= factor;
  }

  /// Add [this] values by [m] values.
  void add(Matrix2 m) {
    m00 += m.m00;
    m01 += m.m01;
    m10 += m.m10;
    m11 += m.m11;
  }

  /// Subtract [this] values by [m] values.
  void sub(Matrix2 m) {
    m00 -= m.m00;
    m01 -= m.m01;
    m10 -= m.m10;
    m11 -= m.m11;
  }

  /// Transform [this] to [Vector2] by multiply to [v].
  Vector2 transform(Vector2 v) {
    final x = v.x;
    final y = v.y;
    return new Vector2((m00 * x) + (m01 * y), (m10 * x) + (m11 * y));
  }

  String toString() {
    return "Matrix2:\n"
        "${m00}|${m01}\n"
        "${m10}|${m11}";
  }

  /// Check is [this] equal to [other]
  bool operator ==(other) {
    return (other is Matrix2) &&
        (m00 == other.m00) &&
        (m01 == other.m01) &&
        (m10 == other.m10) &&
        (m11 == other.m11);
  }

  /// Add [this] values by [m] values and return new matrix.
  Matrix2 operator +(Matrix2 m) {
    return clone()..add(m);
  }

  /// Subtract [this] values by [m] values and return new matrix.
  Matrix2 operator -(Matrix2 m) {
    return clone()..sub(m);
  }

  /// Negate [this] values and return new matrix.
  Matrix2 operator -() {
    return clone()..negate();
  }

  /// Multiply [this] to [value].
  ///
  /// [value] can be [Vector2], [Matrix2] or [double].
  /// Return [Matrix2] or [Vector2] relatives to argument.
  operator *(value) {
    if (value is Matrix2) {
      return this.clone()..multiply(value);
    }
    if (value is double) {
      return this.clone()..scale(value);
    }
    if (value is Vector2) {
      return this.clone()..transform(value);
    }
    throw new ArgumentError(value);
  }

  /// Get matrix element on row: 0, col: 0.
  double get m00 => _storage[0];

  /// Get matrix element on row: 0, col: 1.
  double get m01 => _storage[1];

  /// Get matrix element on row: 1, col: 0.
  double get m10 => _storage[2];

  /// Get matrix element on row: 1, col: 1.
  double get m11 => _storage[3];

  /// Set row: 0, col: 0.
  set m00(double m00) => _storage[0] = m00;

  /// Set row: 0, col: 1.
  set m01(double m01) => _storage[1] = m01;

  /// Set row: 1, col: 0.
  set m10(double m10) => _storage[2] = m10;

  /// Set row: 1, col: 1.
  set m11(double m11) => _storage[3] = m11;
}
