part of ose;

/// Circle shape.
class Circle extends Shape {
  /// Number of vertices points.
  int _points;

  /// Create a new circle, where
  /// [points] - number of vertices point of a circle.
  Circle({ Color color, int points: 3 })
      : super(vertices: _getCircleVerticesByPoints(points), color: color) {
    _points = points;
  }

  /// Calculates vertices positions by number of income points.
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
    return new Circle(points: _points)..copyFrom(this);
  }
}
