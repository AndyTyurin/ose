part of ose_webgl;

class Circle extends Shape {
  int _points;

  Circle([int points = 3])
      : super(
            vertices: new Float32List.fromList(
                utils.getCircleVerticesByPoints(points)),
            color: new ose.SolidColor(new ose.Color([255, 255, 255, 255]))) {
    _points = points;
  }

  Circle clone() {
    return new Circle(_points)..copyFrom(this);
  }
}
