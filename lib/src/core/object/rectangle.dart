part of ose;

class Rectangle extends GameObject
    with VerticesMixin, ColorsMixin, FilterMixin {
  /// Create a new rectangle.
  Rectangle() {
    this.setupVerticesFromList([-1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0]);
    this.setupDefaultColors(this.vertices.length ~/ 2);
  }
}
