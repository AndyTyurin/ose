part of ose.core.shader;

class Attribute {
  /// Attribute name.
  String _name;

  /// Uses common WebGL types.
  int _type;

  /// Holds data.
  List _storage;

  /// Buffer usage.
  ///
  /// [true] when [Attribute] has been created as one of constructors below:
  /// [Attribute.IntArray4], [Attribute.FloatArray1],
  /// [Attribute.FloatArray2], [Attribute.FloatArray3],
  /// [Attribute.FloatArray4].
  bool _useBuffer;

  Attribute._internal(this._name, this._type, this._storage);

  Attribute._internalBuffer(this._name, this._type, this._storage)
      : _useBuffer = true;

  /// i1
  factory Attribute.Int1(String name, int v) =>
      new Attribute._internal(name, webGL.INT, new Int8List(1)..add(v));

  /// f1
  factory Attribute.Float1(String name, double v) =>
      new Attribute._internal(name, webGL.FLOAT_VEC2, new Float32List(1)..add(v));

  /// f2
  factory Attribute.Float2(String name, Vector2 v) =>
      new Attribute._internal(name, webGL.FLOAT_VEC2, v.storage);

  /// f3
  factory Attribute.Float3(String name, Vector3 v) =>
      new Attribute._internal(name, webGL.FLOAT_VEC3, v.storage);

  /// f4
  factory Attribute.Float4(String name, Vector4 v) =>
      new Attribute._internal(name, webGL.FLOAT_VEC4, v.storage);

  /// fv1
  factory Attribute.FloatArray1(String name, List<double> data) =>
      new Attribute._internalBuffer(
          name, webGL.FLOAT, new Float32List.fromList(data));

  /// fv2
  factory Attribute.FloatArray2(String name, List<double> data) =>
      new Attribute._internalBuffer(
          name, webGL.FLOAT_VEC2, new Float32List.fromList(data));

  /// fv3
  factory Attribute.FloatArray3(String name, List<double> data) =>
      new Attribute._internalBuffer(
          name, webGL.FLOAT_VEC3, new Float32List.fromList(data));

  /// fv4
  factory Attribute.FloatArray4(String name, List<double> data) =>
      new Attribute._internalBuffer(
          name, webGL.FLOAT_VEC4, new Float32List.fromList(data));

  String get name => _name;

  int get type => _type;

  List get storage => _storage;

  bool get useBuffer => _useBuffer;
}
