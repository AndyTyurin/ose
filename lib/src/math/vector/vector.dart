part of ose_math;

abstract class Vector {
  /// Value storage.
  Float32List _storage;

  Vector(Float32List storage) {
    _storage = storage;
  }

  Float32List get storage => _storage;
}
