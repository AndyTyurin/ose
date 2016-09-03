part of ose_webgl;

class Particles extends ose.GameObject {
  Filter filter;

  /// Vertices coordinates.
  Float32List _glVertices;

  /// Colors values.
  Float32List _glColors;

  int _count;

  ose.Color _color;

  Particles({int count, ose.Color color}) {
    _count = count;
    _color = color;
    // TODO: Set gl vertices and gl colors.
  }
}
