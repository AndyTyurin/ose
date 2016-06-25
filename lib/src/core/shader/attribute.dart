part of ose;

class Attribute {
  /// WebGL Rendering context.
  static webGL.RenderingContext gl;

  /// Type.
  Type _type;

  /// Holds data.
  Float32List _storage;

  /// WebGL buffer.
  webGL.Buffer _buffer;

  /// Attribute location.
  int location;

  /// Is attribute storage was changed?
  bool _isChanged;

  Attribute._internal(this._type, List<double> storage, [webGL.Buffer buffer]) {
    this._storage =
        (storage != null) ? new Float32List.fromList(storage) : null;
    this._buffer = buffer;
    this._isChanged = true;
  }

  Attribute._internalBuffer(Type type, List<double> storage)
      : this._internal(type, storage, gl.createBuffer());

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
      new Attribute._internalBuffer(Type.Float1, data);

  /// fv2
  factory Attribute.FloatArray2([List<double> data]) =>
      new Attribute._internalBuffer(Type.Float2, data);

  /// fv3
  factory Attribute.FloatArray3([List<double> data]) =>
      new Attribute._internalBuffer(Type.Float3, data);

  /// fv4
  factory Attribute.FloatArray4([List<double> data]) =>
      new Attribute._internalBuffer(Type.Float4, data);

  /// Update storage values.
  ///
  /// Use [update] if you want to change attribute's values.
  void update(dynamic value) {
    var storage = new Float32List(1);

    if (value is double) {
      storage[0] = value;
    } else if (value is Vector || value is Matrix) {
      storage = value.storage;
    } else if (value is Float32List) {
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

  /// Remove WebGL buffer.
  ///
  /// In really rare cases we need to remove uniform at all.
  /// Before we should use [removeBuffer] to clear buffer on GPU side.
  void removeBuffer() {
    gl.deleteBuffer(_buffer);
    this._buffer = null;
  }

  Type get type => this._type;

  Float32List get storage => this._storage;

  bool get useBuffer => this._buffer != null;

  webGL.Buffer get buffer => this._buffer;

  bool get isChanged => this._isChanged;
}
