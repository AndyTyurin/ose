part of ose_webgl;

class Uniform {
  /// Type.
  Type _type;

  /// Hold data.
  /// Can be [Float32List] or [Int8List].
  List _storage;

  /// Is uniform array?
  bool _useArray;

  /// Is uniform storage was changed?
  bool _isChanged;

  /// Uniform location.
  webGL.UniformLocation location;

  Uniform._internal(this._type, List storage, [bool isArray = false]) {
    if (storage != null) {
      this._storage = (storage.length > 0 && storage[0] is int)
          ? new Uint8List.fromList(storage)
          : new Float32List.fromList(storage);
    }
    this._useArray = isArray;
    this._isChanged = true;
  }

  Uniform._internalArray(Type type, List storage)
      : this._internal(type, storage, true);

  /// i1
  factory Uniform.Int1([int i0]) => new Uniform._internal(Type.Int1, [i0]);

  /// f1
  factory Uniform.Float1([double f0]) =>
      new Uniform._internal(Type.Float1, [f0]);

  /// f2
  factory Uniform.Float2([double f0, double f1 = 0.0]) {
    return new Uniform._internal(Type.Float2, [f0, f1]);
  }

  /// f3
  factory Uniform.Float3([double f0, double f1 = 0.0, double f2 = 0.0]) {
    return new Uniform._internal(Type.Float3, [f0, f1, f2]);
  }

  /// f4
  factory Uniform.Float4(
      [double f0, double f1 = 0.0, double f2 = 0.0, double f3 = 0.0]) {
    return new Uniform._internal(Type.Float4, [f0, f1, f2, f3]);
  }

  /// fv1
  factory Uniform.FloatArray1([List<double> data]) {
    return new Uniform._internalArray(Type.Float1, data);
  }

  /// fv2
  factory Uniform.FloatArray2([List<double> data]) {
    return new Uniform._internalArray(Type.Float2, data);
  }

  /// fv3
  factory Uniform.FloatArray3([List<double> data]) {
    return new Uniform._internalArray(Type.Float3, data);
  }

  /// fv4
  factory Uniform.FloatArray4([List<double> data]) {
    return new Uniform._internalArray(Type.Float4, data);
  }

  /// mf2v
  factory Uniform.Mat2([List<double> data]) {
    return new Uniform._internal(Type.Mat2, data);
  }

  /// mf3v
  factory Uniform.Mat3([List<double> data]) {
    return new Uniform._internal(Type.Mat3, data);
  }

  /// mf4v
  // factory Uniform.Mat4([List<double> data]) {
  //   return new Uniform._internal(Type.Mat4, data);
  // }

  /// Update storage values.
  ///
  /// Use [update] if you want to change uniform's values.
  void update(dynamic value) {
    var storage = new Float32List(1);

    if (value is double) {
      storage[0] = value;
    } else if (value is math.Vector || value is math.Matrix) {
      storage = value.storage;
    } else if (value is Float32List || value is Int8List) {
      storage = value;
    } else {
      throw ArgumentError;
    }

    if (storage != this._storage) {
      this._isChanged = true;
      this._storage = storage;
    }
  }

  /// Reset changed state.
  ///
  /// When storage values were changed by using of [update] method,
  /// State will be changed to get knows, does changes should be
  /// applied to GPU or not. After values will be sent to GPU,
  /// [resetChangedState] should be invoked to reset state.
  void resetChangedState() {
    this._isChanged = false;
  }

  Type get type => this._type;

  List get storage => this._storage;

  bool get useArray => this._useArray;

  bool get isChanged => this._isChanged;
}
