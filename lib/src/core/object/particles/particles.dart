part of ose_webgl;

class Particles extends GameObject {
  Filter filter;

  /// Vertices coordinates.
  Float32List _glVertices;

  /// Colors values.
  Float32List _glColors;

  int _count;

  Color _color;

  Particles({int count, Color color}) {
    _count = count;
    _color = color;
    // TODO: Set gl vertices and gl colors.
  }
}
