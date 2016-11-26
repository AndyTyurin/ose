part of ose_math;

/// Matrix 3x3.
/// Values are in column major order.
class Matrix3 extends Matrix {
  /// New matrix.
  Matrix3() : super(new Float32List(9));

  /// New identity matrix.
  factory Matrix3.identity() => new Matrix3()..setIdentity();

  /// Copy matrix from [other].
  factory Matrix3.copy(Matrix3 other) => new Matrix3()..setFrom(other);

  /// New matrix from values list.
  factory Matrix3.fromList(List values) => new Matrix3()
    ..setValues(values[0], values[1], values[2], values[3], values[4],
        values[5], values[6], values[7], values[8]);

  /// New matrix from values.
  factory Matrix3.fromValues(double m00, double m01, double m02, double m10,
          double m11, double m12, double m20, double m21, double m22) =>
      new Matrix3()..setValues(m00, m01, m02, m10, m11, m12, m20, m21, m22);

  /// New translation matrix from vector.
  factory Matrix3.translationFromVector(Vector2 v) =>
      new Matrix3()..setTranslationFromVector(v);

  /// New scale matrix from vector.
  factory Matrix3.scaleFromVector(Vector2 v) =>
      new Matrix3()..setScaleFromVector(v);

  /// New rotation matrix from angle.
  factory Matrix3.rotationFromAngle(double angle) =>
      new Matrix3()..setRotationFromAngle(angle);

  /// New 2D projection matrix.
  factory Matrix3.projection(int width, int height, double scale) =>
      new Matrix3()..setProjection(width, height, scale);

  // Set up translation matrix.
  void setTranslationFromVector(Vector2 v) {
    setIdentity();
    m20 = v.x;
    m21 = v.y;
  }

  // Set up scalling matrix.
  void setScaleFromVector(Vector2 v) {
    setIdentity();
    m00 = v.x;
    m11 = v.y;
  }

  // Set up rotation matrix from angle.
  void setRotationFromAngle(double angle) {
    double c = math.cos(angle);
    double s = -math.sin(angle);
    setIdentity();
    m00 = c;
    m10 = -s;
    m01 = s;
    m11 = c;
  }

  // Set up 2D projection matrix.
  void setProjection(int width, int height, double scale) {
    setIdentity();
    double min = math.min(width, height);
    m00 = min / width * scale / 2;
    m11 = min / height * scale / 2;
  }

  /// Makes as identity matrix.
  void setIdentity() {
    m00 = 1.0;
    m01 = 0.0;
    m02 = 0.0;
    m10 = 0.0;
    m11 = 1.0;
    m12 = 0.0;
    m20 = 0.0;
    m21 = 0.0;
    m22 = 1.0;
  }

  /// Apply values from [other] matrix.
  void setFrom(Matrix3 other) {
    m00 = other.m00;
    m01 = other.m01;
    m02 = other.m02;
    m10 = other.m10;
    m11 = other.m11;
    m12 = other.m12;
    m20 = other.m20;
    m21 = other.m21;
    m22 = other.m22;
  }

  /// Set specific values.
  void setValues(double m00, double m01, double m02, double m10, double m11,
      double m12, double m20, double m21, double m22) {
    this.m00 = m00;
    this.m01 = m01;
    this.m02 = m02;
    this.m10 = m10;
    this.m11 = m11;
    this.m12 = m12;
    this.m20 = m20;
    this.m21 = m21;
    this.m22 = m22;
  }

  /// Negate matrix.
  void negate() {
    m00 = -m00;
    m01 = -m01;
    m02 = -m02;
    m10 = -m10;
    m11 = -m11;
    m12 = -m12;
    m20 = -m20;
    m21 = -m21;
    m22 = -m22;
  }

  /// Transpose matrix.
  void transpose() {
    double temp = m10;
    m10 = m01;
    m01 = temp;
    temp = m20;
    m20 = m02;
    m02 = temp;
    temp = m12;
    m12 = m21;
    m21 = temp;
  }

  /// Clone to new one.
  Matrix3 clone() => new Matrix3.copy(this);

  /// Multiply by [m].
  void multiply(Matrix3 m) {
    final n00 = m00;
    final n01 = m01;
    final n02 = m02;
    final n10 = m10;
    final n11 = m11;
    final n12 = m12;
    final n20 = m20;
    final n21 = m21;
    final n22 = m22;
    final j00 = m.m00;
    final j01 = m.m01;
    final j02 = m.m02;
    final j10 = m.m10;
    final j11 = m.m11;
    final j12 = m.m12;
    final j20 = m.m20;
    final j21 = m.m21;
    final j22 = m.m22;
    m00 = (n00 * j00) + (n01 * j10) + (n02 * j20);
    m01 = (n00 * j01) + (n01 * j11) + (n02 * j21);
    m02 = (n00 * j02) + (n01 * j12) + (n02 * j22);
    m10 = (n10 * j00) + (n11 * j10) + (n12 * j20);
    m11 = (n10 * j01) + (n11 * j11) + (n12 * j21);
    m12 = (n10 * j02) + (n11 * j12) + (n12 * j21);
    m20 = (n20 * j00) + (n21 * j10) + (n22 * j20);
    m21 = (n20 * j01) + (n21 * j11) + (n22 * j21);
    m22 = (n20 * j01) + (n21 * j12) + (n22 * j22);
  }

  /// Scale by [factor]
  void scale(double factor) {
    m00 *= factor;
    m01 *= factor;
    m02 *= factor;
    m10 *= factor;
    m11 *= factor;
    m12 *= factor;
    m20 *= factor;
    m21 *= factor;
    m22 *= factor;
  }

  /// Add values by [m] values.
  void add(Matrix3 m) {
    m00 += m.m00;
    m01 += m.m01;
    m02 += m.m02;
    m10 += m.m10;
    m11 += m.m11;
    m12 += m.m12;
    m20 += m.m20;
    m21 += m.m21;
    m22 += m.m22;
  }

  /// Subtract values by [m] values.
  void sub(Matrix3 m) {
    m00 -= m.m00;
    m01 -= m.m01;
    m02 -= m.m02;
    m10 -= m.m10;
    m11 -= m.m11;
    m12 -= m.m12;
    m20 -= m.m20;
    m21 -= m.m21;
    m22 -= m.m22;
  }

  /// Transform to [Vector3] by multiply to [v].
  Vector3 transform(Vector3 v) {
    final x = v.x;
    final y = v.y;
    final z = v.z;
    return new Vector3((m00 * x) + (m10 * y) + (m20 * z),
        (m01 * x) + (m11 * y) + (m21 * z), (m02 * x) + (m12 * y) + (m22 * z));
  }

  String toString() {
    return "Matrix3:\n"
        "${m00}|${m01}|${m02}\n"
        "${m10}|${m11}|${m12}\n"
        "${m20}|${m21}|${m22}";
  }

  /// Check is equal to [other]
  bool operator ==(other) {
    return (other is Matrix3) &&
        (double.parse(m00.toStringAsFixed(15)) ==
            double.parse(other.m00.toStringAsFixed(15))) &&
        (double.parse(m01.toStringAsFixed(15)) ==
            double.parse(other.m01.toStringAsFixed(15))) &&
        (double.parse(m02.toStringAsFixed(15)) ==
            double.parse(other.m02.toStringAsFixed(15))) &&
        (double.parse(m10.toStringAsFixed(15)) ==
            double.parse(other.m10.toStringAsFixed(15))) &&
        (double.parse(m11.toStringAsFixed(15)) ==
            double.parse(other.m11.toStringAsFixed(15))) &&
        (double.parse(m12.toStringAsFixed(15)) ==
            double.parse(other.m12.toStringAsFixed(15))) &&
        (double.parse(m20.toStringAsFixed(15)) ==
            double.parse(other.m20.toStringAsFixed(15))) &&
        (double.parse(m21.toStringAsFixed(15)) ==
            double.parse(other.m21.toStringAsFixed(15))) &&
        (double.parse(m22.toStringAsFixed(15)) ==
            double.parse(other.m22.toStringAsFixed(15)));
  }

  /// Add [this] values by [m] values and return new matrix.
  Matrix3 operator +(Matrix3 m) {
    return clone()..add(m);
  }

  /// Subtract [this] values by [m] values and return new matrix.
  Matrix3 operator -(Matrix3 m) {
    return clone()..sub(m);
  }

  /// Negate [this] values and return new matrix.
  Matrix3 operator -() {
    return clone()..negate();
  }

  /// Multiply by [value].
  ///
  /// [value] can be [Vector3], [Matrix3] or [double].
  /// Return [Matrix3] or [Vector3] relatives to argument.
  operator *(value) {
    if (value is Matrix3) {
      return clone()..multiply(value);
    }
    if (value is double) {
      return clone()..scale(value);
    }
    if (value is Vector3) {
      return clone()..transform(value);
    }
    throw new ArgumentError(value);
  }

  /// Get row: 0, col: 0.
  double get m00 => _storage[0];

  /// Get row: 0, col: 1.
  double get m01 => _storage[1];

  /// Get row: 0, col: 2.
  double get m02 => _storage[2];

  /// Get row: 1, col: 0.
  double get m10 => _storage[3];

  /// Get row: 1, col: 1.
  double get m11 => _storage[4];

  /// Get row: 1, col: 2.
  double get m12 => _storage[5];

  /// Get row: 2, col: 0.
  double get m20 => _storage[6];

  /// Get row: 2, col: 1.
  double get m21 => _storage[7];

  /// Get row: 2, col: 2.
  double get m22 => _storage[8];

  /// Get right vector.
  Vector3 get right => new Vector3(m00, m01, m02);

  /// Get up vector.
  Vector3 get up => new Vector3(m10, m11, m12);

  /// Get forward vector.
  Vector3 get forward => new Vector3(m20, m21, m22);

  /// Set row: 0, col: 0.
  set m00(double m00) => _storage[0] = m00;

  /// Set row: 0, col: 1.
  set m01(double m01) => _storage[1] = m01;

  /// Set row: 0, col: 2.
  set m02(double m02) => _storage[2] = m02;

  /// Set row: 1, col: 0.
  set m10(double m10) => _storage[3] = m10;

  /// Set row: 1, col: 1.
  set m11(double m11) => _storage[4] = m11;

  /// Set row: 1, col: 2.
  set m12(double m12) => _storage[5] = m12;

  /// Set row: 2, col: 0.
  set m20(double m20) => _storage[6] = m20;

  /// Set row: 2, col: 1.
  set m21(double m21) => _storage[7] = m21;

  /// Set row: 2, col: 2.
  set m22(double m22) => _storage[8] = m22;
}
