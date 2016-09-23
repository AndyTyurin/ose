part of ose;

class Triangle extends Shape {
  Triangle() : super(vertices: getTriangleVerticesAroundCenter());

  static Float32List getTriangleVerticesAroundCenter() {
    double topVertexCoord = sin(PI / 3);
    double delta = (1 - topVertexCoord) / 2;
    List<double> vertices = [
      0.0,
      delta,
      0.5,
      topVertexCoord + delta,
      1.0,
      delta
    ];
    return new Float32List.fromList(vertices);
  }

  clone() {
    return new Triangle()..copyFrom(this);
  }
}
