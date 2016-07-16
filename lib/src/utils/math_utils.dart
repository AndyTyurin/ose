part of ose_utils;

Matrix3 setRotationMatrixFromVector(Vector2 v, Vector2 axis) {
  double rad = getRadiansFromVector(v, axis);
  return setRotationMatrixFromRadians(rad);
}

Matrix3 setRotationMatrixFromRadians(double radians) {
  double c = -math.cos(radians);
  double s = -math.sin(radians);
  return new Matrix3.fromValues(
      c, -s, 0.0,
      s, c, 0.0,
      0.0, 0.0, 1.0
  );
}

Matrix3 setRotationMatrix(double x, double y) {
  return new Matrix3.fromValues(
      x, y, 0.0,
      -y, x, 0.0,
      0.0, 0.0, 1.0
  );
}

/// Create translation matrix.
Matrix3 setTranslationMatrix(double tx, double ty) {
  return new Matrix3.fromValues(
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    tx - 1.0, -ty, 1.0
  );
}

/// Create scale matrix.
Matrix3 setScaleMatrix(double sx, double sy) {
  return new Matrix3.fromValues(
    sx, 0.0, 0.0,
    0.0, sy, 0.0,
    0.0, 0.0, 1.0
  );
}

/// Create 2D projection matrix.
Matrix3 setProjectionMatrix(num width, num height, [num scale]) {
  if (scale != null) {
    width = scale * 100 / width;
    height = scale * 100 / height;
  }
  return new Matrix3.fromValues(
    width, 0.0, -1.0,
    0.0, -height, 1.0,
    0.0, 0.0, 1.0
  );
}

double getRadiansFromVector(Vector2 v, Vector2 axis) {
  v.normalize();
  axis.normalize();
  int direction = 1;
  if (v.x < 0) {
    direction = -1;
  }
  return direction * math.acos(v * axis);
}

/// Transform degrees to radians.
double deg2Rad(double degrees) {
  return degrees * math.PI / 180;
}
