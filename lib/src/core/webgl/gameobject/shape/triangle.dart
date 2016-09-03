part of ose_webgl;

class Triangle extends Shape {
  Triangle()
      : super(
            vertices: new Float32List.fromList([0.0, 0.0, 0.5, 1.0, 1.0, 0.0]),
            color: new ose.SolidColor(new ose.Color([255, 255, 255, 255])));

  clone() {
    return new Triangle()..copyFrom(this);
  }
}
