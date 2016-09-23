part of ose;

class Circle extends Shape {
  int _points;

  Circle([int points = 3])
      : super(vertices: _getCircleVerticesByPoints(points)) {
    _points = points;
  }

  static Float32List _getCircleVerticesByPoints(int points) {
    points = max(4, points);
    List<double> vertices = <double>[];
    for (int i = 1; i < (points + 1); i += 2) {
      vertices
          .add(cos((2 * PI - (2 * PI - 2 * PI / points) * (i - 1))) / 2 + 0.5);
      vertices
          .add(sin((2 * PI - (2 * PI - 2 * PI / points) * (i - 1))) / 2 + 0.5);
      vertices.add(cos((2 * PI - (2 * PI - 2 * PI / points) * i)) / 2 + 0.5);
      vertices.add(sin((2 * PI - (2 * PI - 2 * PI / points) * i)) / 2 + 0.5);
      vertices.add(0.5);
      vertices.add(0.5);
      if (i == points || (points % 2 == 0)) {
        vertices.add(
            cos((2 * PI - (2 * PI - 2 * PI / points) * (i + 1))) / 2 + 0.5);
        vertices.add(
            sin((2 * PI - (2 * PI - 2 * PI / points) * (i + 1))) / 2 + 0.5);
      }
    }
    return new Float32List.fromList(vertices);
  }

  Circle clone() {
    return new Circle(_points)..copyFrom(this);
  }
}
