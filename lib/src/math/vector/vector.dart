library ose.math.vector;

import 'dart:typed_data';
import 'dart:math' as math;

part 'vector2.dart';

class Vector {
  /// World x axis.
  static Vector2 X_AXIS = new Vector2(1.0, 0.0);

  /// World y axis.
  static Vector2 Y_AXIS = new Vector2(0.0, 1.0);

  Float32List _storage;

  Vector(Float32List storage) {
    _storage = storage;
  }

  Float32List get storage => _storage;
}