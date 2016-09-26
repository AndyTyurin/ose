part of ose_math;

class Rect {
  int x0;

  int x1;

  int y0;

  int y1;

  Rect(int x0, int y0, int x1, int y1) {
    setValues(x0, y0, x1, y1);
  }

  setValues(int x0, int y0, int x1, int y1) {
    this.x0 = x0;
    this.y0 = y0;
    this.x1 = x1;
    this.y1 = y1;
  }

  Rect clone() {
    return new Rect(x0, y0, x1, y1);
  }

  Vector4 toIdentityVector4(int maxWidth, int maxHeight) => new Vector4(
      x0 / maxWidth,
      y0 / maxHeight,
      x1 / maxWidth,
      y1 / maxHeight);
}
