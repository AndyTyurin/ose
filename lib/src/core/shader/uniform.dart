part of ose;

/// Uniforms are part of shader programs.
///
/// There are needed to keep data and can be used inside your shader logic for
/// both vertex & fragment.
///
/// Keep in mind, uniforms are constants and it's not necessary to push values
/// to GPU each time to use them in shaders. Only if value has been changed,
/// it's take a place to send data to GPU.
class Uniform {
  static final Function eq = const ListEquality().equals;

  /// Uniform type.
  QualifierType _type;

  /// Uniform data.
  List _storage;

  // Uniform state.
  QualifierState state;

  /// Uniform use array.
  bool _useArray;

  Uniform._internal(this._type, List storage, [bool isArray = false]) {
    if (storage != null) {
      if (_isBoolQualifierType()) {
        storage = storage.map((v) {
          return (v) ? 1 : 0;
        }).toList();
        _storage = (storage.length > 0) ? new Int8List.fromList(storage) : null;
      } else if (_isIntQualifierType()) {
        storage = storage.map((v) {
          return int.parse((v ?? 0).toString());
        }).toList();
        _storage = (storage.length > 0) ? new Int8List.fromList(storage) : null;
      } else {
        storage = storage.map((v) {
          return double.parse((v ?? .0).toString());
        }).toList();
        _storage =
            (storage.length > 0) ? new Float32List.fromList(storage) : null;
      }
    }
    _useArray = isArray;
    state = QualifierState.INITIALIZED;
  }

  /// b1
  factory Uniform.Bool1([bool b0 = false]) =>
      new Uniform._internal(QualifierType.Bool1, [b0]);

  /// b2
  factory Uniform.Bool2([bool b0 = false, bool b1 = false]) =>
      new Uniform._internal(QualifierType.Bool1, [b0, b1]);

  /// b3
  factory Uniform.Bool3([bool b0 = false, bool b1 = false, bool b2 = false]) =>
      new Uniform._internal(QualifierType.Bool1, [b0, b1, b2]);

  /// b4
  factory Uniform.Bool4(
          [bool b0 = false,
          bool b1 = false,
          bool b2 = false,
          bool b3 = false]) =>
      new Uniform._internal(QualifierType.Bool1, [b0, b1, b2, b3]);

  /// bv1
  factory Uniform.BoolArray1([List<bool> data]) {
    return new Uniform._internal(QualifierType.Bool1, data, true);
  }

  /// bv2
  factory Uniform.BoolArray2([List<bool> data]) {
    return new Uniform._internal(QualifierType.Bool2, data, true);
  }

  /// bv3
  factory Uniform.BoolArray3([List<bool> data]) {
    return new Uniform._internal(QualifierType.Bool3, data, true);
  }

  /// bv4
  factory Uniform.BoolArray4([List<bool> data]) {
    return new Uniform._internal(QualifierType.Bool4, data, true);
  }

  /// i1
  factory Uniform.Int1([int i0 = 0]) =>
      new Uniform._internal(QualifierType.Int1, [i0]);

  /// i2
  factory Uniform.Int2([int i0 = 0, int i1 = 0]) =>
      new Uniform._internal(QualifierType.Int2, [i0, i1]);

  /// i3
  factory Uniform.Int3([int i0 = 0, int i1 = 0, int i2 = 0]) =>
      new Uniform._internal(QualifierType.Int3, [i0, i1, i2]);

  /// i4
  factory Uniform.Int4([int i0 = 0, int i1 = 0, int i2 = 0, int i3 = 0]) =>
      new Uniform._internal(QualifierType.Int4, [i0, i1, i2, i3]);

  /// iv1
  factory Uniform.IntArray1([List<int> data]) {
    return new Uniform._internal(QualifierType.Int1, data, true);
  }

  /// iv2
  factory Uniform.IntArray2([List<int> data]) {
    return new Uniform._internal(QualifierType.Int2, data, true);
  }

  /// iv3
  factory Uniform.IntArray3([List<int> data]) {
    return new Uniform._internal(QualifierType.Int3, data, true);
  }

  /// iv4
  factory Uniform.IntArray4([List<int> data]) {
    return new Uniform._internal(QualifierType.Int4, data, true);
  }

  /// f1
  factory Uniform.Float1([double f0 = 0.0]) =>
      new Uniform._internal(QualifierType.Float1, [f0]);

  /// f2
  factory Uniform.Float2([double f0 = 0.0, double f1 = 0.0]) {
    return new Uniform._internal(QualifierType.Float2, [f0, f1]);
  }

  /// f3
  factory Uniform.Float3([double f0 = 0.0, double f1 = 0.0, double f2 = 0.0]) {
    return new Uniform._internal(QualifierType.Float3, [f0, f1, f2]);
  }

  /// f4
  factory Uniform.Float4(
      [double f0 = 0.0, double f1 = 0.0, double f2 = 0.0, double f3 = 0.0]) {
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

  /// Update value that is stored in [Uniform].
  /// [value] can be one of the types below:
  /// * [number] – [int] and [double] will be handled differently;
  /// * [bool];
  /// * [Vector];
  /// * [Matrix];
  /// * [Float32List];
  /// * [Int8List];
  /// * [TypedIdentity].
  ///
  /// At the end, passed [value] will be converted to [Float32List] type, kept
  /// and could be retrived by using of [storage].
  ///
  /// There is a small approach of caching implement for [Attribute].
  /// If passed [value] has been changed since last [update], the state will be
  /// changed [QualifierState.CHANGED], otherwise [QualifierState.CACHED].
  /// At initial, state is equal to [QualifierState.INITIALIZED].
  void update(dynamic value) {
    List storage;

    if (value == null) return;

    if (utils.isNumeric(value)) {
      if (type == QualifierType.Int1) {
        storage = new Int8List.fromList([int.parse(value.toString())]);
      } else {
        storage = new Float32List.fromList([double.parse(value.toString())]);
      }
    } else if (value is bool) {
      storage = new Int8List.fromList([(value) ? 1 : 0]);
    } else if (value is Vector || value is Matrix) {
      storage = new Float32List.fromList(value.storage);
    } else if (value is Float32List) {
      storage = new Float32List.fromList(value);
    } else if (value is Int8List) {
      storage = new Int8List.fromList(value);
    } else if (value is TypedIdentity) {
      storage = value.toTypeIdentity();
    } else {
      window.console.error("Can't update uniform by value ${value}");
      throw ArgumentError;
    }

    if (!eq(_storage, storage)) {
      state = QualifierState.CHANGED;
      _storage = storage;
    } else {
      state = QualifierState.CACHED;
    }
  }

  bool operator ==(Uniform another) {
    return eq(storage, another.storage) &&
        type == another.type &&
        state == another.state;
  }

  bool _isBoolQualifierType() =>
      type == QualifierType.Bool1 ||
      type == QualifierType.Bool2 ||
      type == QualifierType.Bool3 ||
      type == QualifierType.Bool4;

  bool _isIntQualifierType() =>
      type == QualifierType.Int1 ||
      type == QualifierType.Int2 ||
      type == QualifierType.Int3 ||
      type == QualifierType.Int4;

  QualifierType get type => _type;

  List get storage => _storage;

  bool get useArray => _useArray;
}
