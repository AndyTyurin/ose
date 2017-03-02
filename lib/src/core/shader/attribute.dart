part of ose;

/// Attributes are variables in [ShaderProgram].
/// Same as uniforms are used to share data between CPU and GPU parts, but
/// mostly have been used in vertex shader and represents state for each vertex.
class Attribute {
  /// Equalization function.
  static final Function eq = const ListEquality().equals;

  /// Qualifier type.
  final QualifierType _type;

  /// Attribute data.
  Float32List _storage;

  /// WebGL buffer.
  webGL.Buffer _glBuffer;

  /// Attribute state.
  QualifierState state;

  /// Attribute location.
  int _location;

  /// Attribute use buffer.
  bool _shouldUseBuffer;

  Attribute._internal(this._type, List<double> storage,
      [bool useBuffer = true]) {
    if (storage != null) {
      storage.removeWhere((v) => v == null);
      _storage =
          (storage.length > 0) ? new Float32List.fromList(storage) : null;
    }
    _shouldUseBuffer = useBuffer;
    state = QualifierState.INITIALIZED;
  }

  /// b1
  factory Attribute.Bool1([bool b0]) =>
      new Attribute._internal(QualifierType.Bool1, [(b0) ? 1.0 : .0]);

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

  /// Update value that is stored in [Attribute].
  /// [value] can be one of the types below:
  /// * [double];
  /// * [bool];
  /// * [Vector];
  /// * [Matrix];
  /// * [Float32List];
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
    Float32List storage;

    // Convert to [Float32List].
    if (value is double) {
      storage = new Float32List.fromList([value]);
    } else if (value is bool) {
      storage = new Float32List.fromList([(value) ? 1.0 : .0]);
    } else if (value is Vector || value is Matrix) {
      storage = value.storage;
    } else if (value is Float32List) {
      storage = new Float32List.fromList(value);
    } else if (value is TypedIdentity) {
      storage = value.toTypeIdentity();
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

  bool operator ==(Attribute another) {
    return eq(storage, another.storage) &&
        type == another.type &&
        state == another.state;
  }

  QualifierType get type => _type;

  Float32List get storage => _storage;

  bool get shouldUseBuffer => _shouldUseBuffer;

  webGL.Buffer get glBuffer => _glBuffer;

  void set glBuffer(webGL.Buffer buffer) {
    _glBuffer = buffer;
  }

  int get location => _location;

  void set location(int location) {
    _location = location;
  }
}
