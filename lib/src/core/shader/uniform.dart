part of ose;

class Uniform {
  QualifierType _type;

  List _storage;

  /// Uniform use array.
  bool _useArray;

  /// Is uniform storage was changed?
  bool _isChanged;

  /// Uniform location.
  webGL.UniformLocation location;

  Uniform._internal(this._type, List storage, [bool isArray = false]) {
    if (storage != null) {
      storage = storage.map((v) {
        return v ?? 0;
      }).toList();
      _storage = (storage.length > 0 && storage[0] is int)
          ? new Uint8List.fromList(storage)
          : new Float32List.fromList(storage);
    }
    _useArray = isArray;
    _isChanged = true;
  }


  /// i1
  factory Uniform.Int1([int i0]) => new Uniform._internal(QualifierType.Int1, [i0]);

  /// f1
  factory Uniform.Float1([double f0]) =>
      new Uniform._internal(QualifierType.Float1, [f0]);

  /// f2
  factory Uniform.Float2([double f0, double f1 = 0.0]) {
    return new Uniform._internal(QualifierType.Float2, [f0, f1]);
  }

  /// f3
  factory Uniform.Float3([double f0, double f1 = 0.0, double f2 = 0.0]) {
    return new Uniform._internal(QualifierType.Float3, [f0, f1, f2]);
  }

  /// f4
  factory Uniform.Float4(
      [double f0, double f1 = 0.0, double f2 = 0.0, double f3 = 0.0]) {
    return new Uniform._internal(QualifierType.Float4, [f0, f1, f2, f3]);
  }

  /// fv1
  factory Uniform.FloatArray1([List<double> data]) {
    return new Uniform._internal(QualifierType.Float1, data, true);
  }

  /// fv2
  factory Uniform.FloatArray2([List<double> data]) {
    return new Uniform._internal(QualifierType.Float2, data, true);
  }

  /// fv3
  factory Uniform.FloatArray3([List<double> data]) {
    return new Uniform._internal(QualifierType.Float3, data, true);
  }

  /// fv4
  factory Uniform.FloatArray4([List<double> data]) {
    return new Uniform._internal(QualifierType.Float4, data, true);
  }

  /// mf2v
  factory Uniform.Mat2([List<double> data]) {
    return new Uniform._internal(QualifierType.Mat2, data);
  }

  /// mf3v
  factory Uniform.Mat3([List<double> data]) {
    return new Uniform._internal(QualifierType.Mat3, data);
  }

  /// mf4v
  // factory Uniform.Mat4([List<double> data]) {
  //   return new Uniform._internal(QualifierType.Mat4, data);
  // }

  /// Update storage values.
  ///
  /// Use [update] if you want to change uniform's values.
  void update(dynamic value) {
    List storage;

    if (value is double) {
      storage = new Float32List.fromList([value]);
    } else if (value is int) {
      storage = new Int8List.fromList([value]);
    } else if (value is Vector || value is Matrix) {
      storage = value.storage;
    } else if (value is Float32List || value is Int8List) {
      storage = value;
    } else {
      throw ArgumentError;
    }

    if (storage != _storage) {
      _isChanged = true;
      _storage = storage;
    }
  }

  void resetChangedState() {
    _isChanged = false;
  }

  QualifierType get type => _type;

  List get storage => _storage;

  bool get useArray => _useArray;

  bool get isChanged => _isChanged;
}
