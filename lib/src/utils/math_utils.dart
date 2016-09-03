part of ose_utils;

/// Convert degrees to radians.
double deg2Rad(double deg) {
  return deg * PI / 180;
}

/// Convert radians to degrees.
double rad2Deg(double rad) {
  return rad * 180 / PI;
}

/// Get axis angle from vector.
/// Angle could be a value from 0 to 2*PI.
/// If value is negative, it will be added by 2*PI.
double getAxisAngleFromVector(Vector2 v, Vector2 axis) {
  double angle = atan2(v.x, v.y) - atan2(axis.x, axis.y);
  return (angle > 0) ? angle : angle + 2 * PI;
}

/// Get rotation matrix from vector and axis.
Matrix3 getRotationMatrixFromVectorAndAxis(Vector2 v, Vector2 axis) {
  double angle = getAxisAngleFromVector(v, axis);
  return new Matrix3.rotationFromAngle(angle);
}

/// Get vector from axis with angle in radians.
Vector2 getVectorFromAxisAngle(double angle, Vector2 axis) {
  double s = -sin(angle);
  double c = cos(angle);
  return new Vector2(axis.x * c - axis.y * s, axis.x * s + axis.y * c);
}

List<double> getCircleVerticesByPoints(int points) {
  points = max(4, points);
  List<double> vertices = <double>[];
  for (int i = 1; i < (points+1); i+=2) {
    vertices.add(cos((2*PI - (2*PI - 2*PI/points) * (i-1))) / 2 + 0.5);
    vertices.add(sin((2*PI - (2*PI - 2*PI/points) * (i-1))) / 2 + 0.5);
    vertices.add(cos((2*PI - (2*PI - 2*PI/points) * i)) / 2 + 0.5);
    vertices.add(sin((2*PI - (2*PI - 2*PI/points) * i)) / 2 + 0.5);
    vertices.add(0.5);
    vertices.add(0.5);
    if (i == points || (points % 2 == 0)) {
      vertices.add(cos((2*PI - (2*PI - 2*PI/points) * (i+1))) / 2 + 0.5);
      vertices.add(sin((2*PI - (2*PI - 2*PI/points) * (i+1))) / 2 + 0.5);
    }
  }
  return vertices;
}

List<double> getCircleColorsByPoints(int points) {
  points = max(4, points);
  List<double> colors = <double>[];
  for (int i = 0; i < points * 2; i++) {
    colors.addAll([1.0, 1.0, 1.0, 1.0]);
  }
  return colors;
}
