part of ose_math;

abstract class Vector implements TypedIdentity {
  /// Value storage.
  Float32List _storage;

  Vector(Float32List storage) {
    _storage = storage;
  }

  @override
  Float32List toTypeIdentity() => _storage;

  Float32List get storage => _storage;
}
