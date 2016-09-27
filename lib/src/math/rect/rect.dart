part of ose_math;

class Rect {
  num x0;

  num x1;

  num y0;

  num y1;

  Rect(num x0, num y0, num x1, num y1) {
    setValues(x0, y0, x1, y1);
  }

  setValues(num x0, num y0, num x1, num y1) {
    this.x0 = x0;
    this.y0 = y0;
    this.x1 = x1;
    this.y1 = y1;
  }

  Rect clone() {
    return new Rect(x0, y0, x1, y1);
  }

  Vector4 toVector4() {
    return new Vector4(
        x0.toDouble(), y0.toDouble(), x1.toDouble(), y1.toDouble());
  }
}
