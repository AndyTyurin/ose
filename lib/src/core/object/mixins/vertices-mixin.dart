part of ose;

abstract class VerticesMixin {

  Float32List _vertices;

  Float32List get vertices => _vertices;

  set vertices(List<double> vertices) => _vertices = vertices;

  void setupVerticesFromList(List<double> vertices) {
    this._vertices = new Float32List.fromList(vertices);
  }
}