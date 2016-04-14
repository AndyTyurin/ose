part of ose.core.shader;

class Uniform {
  /// Attribute name.
  String _name;

  /// Uses common WebGL types.
  int _type;

  /// Holds data.
  List _storage;

  /// Buffer usage.
  ///
  /// [true] when [Uniform] has been created as one of constructors below:
  /// [Uniform.IntArray4], [Uniform.FloatArray1],
  /// [Uniform.FloatArray2], [Uniform.FloatArray3],
  /// [Uniform.FloatArray4].
  bool _useBuffer;

  Uniform._internal(this._name, this._type, this._storage);

  Uniform._internalBuffer(this._name, this._type, this._storage)
      : _useBuffer = true;

  /// i1
  factory Uniform.Int1(String name, int v) =>
      new Uniform._internal(name, webGL.INT, new Int8List(1)..add(v));

  /// f1
  factory Uniform.Float1(String name, double v) =>
      new Uniform._internal(name, webGL.FLOAT_VEC2, new Float32List(1)..add(v));

  /// f2
  factory Uniform.Float2(String name, Vector2 v) =>
      new Uniform._internal(name, webGL.FLOAT_VEC2, v.storage);

  /// f3
  factory Uniform.Float3(String name, Vector3 v) =>
      new Uniform._internal(name, webGL.FLOAT_VEC3, v.storage);

  /// f4
  factory Uniform.Float4(String name, Vector4 v) =>
      new Uniform._internal(name, webGL.FLOAT_VEC4, v.storage);

  /// fv1
  factory Uniform.FloatArray1(String name, List<double> data) =>
      new Uniform._internalBuffer(name, webGL.FLOAT, new Float32List.fromList(data));

  /// fv2
  factory Uniform.FloatArray2(String name, List<double> data) =>
      new Uniform._internalBuffer(
          name, webGL.FLOAT_VEC2, new Float32List.fromList(data));

  /// fv3
  factory Uniform.FloatArray3(String name, List<double> data) =>
      new Uniform._internalBuffer(
          name, webGL.FLOAT_VEC3, new Float32List.fromList(data));

  /// fv4
  factory Uniform.FloatArray4(String name, List<double> data) =>
      new Uniform._internalBuffer(
          name, webGL.FLOAT_VEC4, new Float32List.fromList(data));

  /// mf2v
  factory Uniform.Mat2(String name, Matrix2 v) =>
      new Uniform._internal(name, webGL.FLOAT_MAT2, v.storage);

  /// mf3v
  factory Uniform.Mat3(String name, Matrix3 v) =>
      new Uniform._internal(name, webGL.FLOAT_MAT3, v.storage);

  /// mf4v
  factory Uniform.Mat4(String name, Matrix4 v) =>
      new Uniform._internal(name, webGL.FLOAT_MAT4, v.storage);

  String get name => _name;

  int get type => _type;

  List get storage => _storage;

  bool get useBuffer => _useBuffer;
}
