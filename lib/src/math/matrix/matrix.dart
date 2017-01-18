part of ose_math;

abstract class Matrix implements TypedIdentity {
  /// Storage with matrix values.
  Float32List _storage;

  Matrix(Float32List storage) {
    _storage = storage;
  }

  @override
  Float32List toTypeIdentity() => _storage;

  Float32List get storage => _storage;
}
