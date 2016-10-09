part of ose;

class Attribute {
  static final Function eq = const ListEquality().equals;

  /// Qualifier type.
  QualifierType _type;

  /// Hold data.
  Float32List _storage;

  /// WebGL buffer.
  webGL.Buffer _buffer;

  // Attribute state.
  QualifierState state;

  /// Attribute location.
  int _location;

  /// Is attribute location was bound.
  bool _isLocationBound;

  /// Attribute use buffer.
  bool _useBuffer;

  Attribute._internal(this._type, List<double> storage,
      [bool useBuffer = true]) {
    if (storage != null) {
      storage.removeWhere((v) => v == null);
      _storage =
          (storage.length > 0) ? new Float32List.fromList(storage) : null;
    }
    _useBuffer = useBuffer;
    _isLocationBound = false;
    state = QualifierState.INITIALIZED;
  }

  /// f1
  factory Attribute.Float1([double f0]) =>
      new Attribute._internal(QualifierType.Float1, [f0]);

  /// f2
  factory Attribute.Float2([double f0, double f1]) =>
      new Attribute._internal(QualifierType.Float2, [f0, f1]);

  /// f3
  factory Attribute.Float3([double f0, double f1, double f2]) =>
      new Attribute._internal(QualifierType.Float3, [f0, f1, f2]);

  /// f4
  factory Attribute.Float4([double f0, double f1, double f2, double f3]) =>
      new Attribute._internal(QualifierType.Float4, [f0, f1, f2, f3]);

  /// fv1
  factory Attribute.FloatArray1([List<double> data]) =>
      new Attribute._internal(QualifierType.Float1, data, true);

  /// fv2
  factory Attribute.FloatArray2([List<double> data]) =>
      new Attribute._internal(QualifierType.Float2, data, true);

  /// fv3
  factory Attribute.FloatArray3([List<double> data]) =>
      new Attribute._internal(QualifierType.Float3, data, true);

  /// fv4
  factory Attribute.FloatArray4([List<double> data]) =>
      new Attribute._internal(QualifierType.Float4, data, true);

  void update(dynamic value) {
    Float32List storage;

    if (value is double) {
      storage = new Float32List.fromList([value]);
    } else if (value is Vector || value is Matrix) {
      storage = value.storage;
    } else if (value is Float32List) {
      storage = new Float32List.fromList(value);
    } else {
      throw ArgumentError;
    }

    if (!eq(_storage, storage)) {
      state = QualifierState.CHANGED;
    } else {
      state = QualifierState.CACHED;
    }

    _storage = storage;
  }

  void bindLocation() {
    _isLocationBound = true;
  }

  bool operator ==(Attribute another) {
    return eq(storage, another.storage) &&
        type == another.type &&
        state == another.state;
  }

  QualifierType get type => _type;

  Float32List get storage => _storage;

  bool get useBuffer => _useBuffer;

  webGL.Buffer get buffer => _buffer;

  void set buffer(webGL.Buffer buffer) {
    _buffer = buffer;
  }

  int get location => _location;

  void set location(int location) {
    _location = location;
    _isLocationBound = false;
  }

  bool get isLocationBound => _isLocationBound;
}
