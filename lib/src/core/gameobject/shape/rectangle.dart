part of ose_webgl;

class Rectangle extends Shape {
  Rectangle()
      : super(
            vertices: new Float32List.fromList(
                [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]),
            color: new ose.SolidColor(new ose.Color([255, 255, 255, 255])));

  clone() {
    return new Rectangle()..copyFrom(this);
  }
}
