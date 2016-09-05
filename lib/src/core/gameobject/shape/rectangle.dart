part of ose;

class Rectangle extends Shape {
  Rectangle()
      : super(vertices: new Float32List.fromList(
            [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]));

  clone() {
    return new Rectangle()..copyFrom(this);
  }
}
