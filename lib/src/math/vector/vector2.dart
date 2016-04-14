part of ose.math.vector;

class Vector2 extends Vector {
  Vector2([double x = 0.0, double y = 0.0]) : super([x,y]);

  /// Rotate vector.
  Vector2 rotate(double degrees) {
    double rad = degrees * math.PI / 180;
    double sin = math.sin(rad);
    double cos = math.cos(rad);
    double tx = x;
    double ty = y;
    storage[0] = cos * tx - sin * ty;
    storage[1] = sin * tx - cos * ty;
    return this;
  }

  /// Translate vector.
  Vector2 translate(double x, double y) {
    storage[0] = this.x + x;
    storage[1] = this.y + y;
    return this;
  }

  /// Translate vector on x.
  Vector translateX(double x) {
    storage[0] = this.x + x;
    return this;
  }

  /// Translate vector on y.
  Vector2 translateY(double y) {
    storage[1] = this.y + y;
    return this;
  }

  /// Scale vector
  Vector2 scale(double factor) {
    storage[0] = this.x * factor;
    storage[1] = this.y * factor;
    return this;
  }

  /// Scale vector on x.
  Vector2 scaleX(double x) {
    storage[0] = this.x * x;
    return this;
  }

  /// Scale vector on y.
  Vector2 scaleY(double y) {
    storage[1] = this.y * y;
    return this;
  }

  double get x => storage[0];

  void set x(double x) {
    storage[0] = x;
  }

  double get y => storage[1];

  void set y(double y) {
    storage[1] = y;
  }

}
