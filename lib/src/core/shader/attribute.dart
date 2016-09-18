part of ose;

class Attribute {
  /// Attribute type.
  Type _type;

  /// Hold data.
  Float32List _storage;

  /// WebGL buffer.
  webGL.Buffer _buffer;

  /// Attribute location.
  int location;

  /// Attribute storage was changed.
  bool _isChanged;

  /// Attribute use buffer.
  bool _useBuffer;

  Attribute._internal(this._type, List<double> storage, [bool useBuffer = true]) {
    if (storage != null) {
      storage.removeWhere((v) => v == null);
      _storage =
          (storage.length > 0) ? new Float32List.fromList(storage) : null;
    }
    _isChanged = true;
    _useBuffer = useBuffer;
  }

  /// f1
  factory Attribute.Float1([double f0]) =>
      new Attribute._internal(Type.Float1, [f0]);

  /// f2
  factory Attribute.Float2([double f0, double f1]) =>
      new Attribute._internal(Type.Float2, [f0, f1]);

  /// f3
  factory Attribute.Float3([double f0, double f1, double f2]) =>
      new Attribute._internal(Type.Float3, [f0, f1, f2]);

  /// f4
  factory Attribute.Float4([double f0, double f1, double f2, double f3]) =>
      new Attribute._internal(Type.Float4, [f0, f1, f2, f3]);

  /// fv1
  factory Attribute.FloatArray1([List<double> data]) =>
      new Attribute._internal(Type.Float1, data, true);

  /// fv2
  factory Attribute.FloatArray2([List<double> data]) =>
      new Attribute._internal(Type.Float2, data, true);

  /// fv3
  factory Attribute.FloatArray3([List<double> data]) =>
      new Attribute._internal(Type.Float3, data, true);

  /// fv4
  factory Attribute.FloatArray4([List<double> data]) =>
      new Attribute._internal(Type.Float4, data, true);

  void update(dynamic value) {
    Float32List storage;

    if (value is double) {
      storage = new Float32List.fromList([value]);
    } else if (value is Vector || value is Matrix) {
      storage = value.storage;
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

  Type get type => _type;

  Float32List get storage => _storage;

  bool get useBuffer => _useBuffer;

  webGL.Buffer get buffer => _buffer;

  void set buffer(webGL.Buffer buffer) {
    _buffer = buffer;
  }

  bool get isChanged => _isChanged;
}
