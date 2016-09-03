part of ose_math;

abstract class Matrix {
  /// Storage with matrix values.
  Float32List _storage;

  Matrix(Float32List storage) {
    _storage = storage;
  }

  Float32List get storage => _storage;
}
