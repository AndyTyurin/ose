part of ose;

class Triangle extends GameObject with VerticesMixin, ColorsMixin, FilterMixin {
  /// Create a new triangle.
  Triangle() {
    this.setupVerticesFromList([-1.0, -1.0, 0.0, 1.0, 1.0, -1.0]);
    this.setupDefaultColors(this.vertices.length ~/ 2);
  }
}
