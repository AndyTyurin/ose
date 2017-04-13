part of ose;

/// Rectangle shape.
class Rectangle extends Shape {
  Rectangle({ Color color })
      : super(new Float32List.fromList(
            [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]), color: color);

  clone() {
    return new Rectangle()..copyFrom(this);
  }
}
