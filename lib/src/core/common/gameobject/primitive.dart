part of ose;

abstract class Primitive extends GameObject {
  Primitive({Vector2 position, Vector2 rotation, Vector2 scale})
      : super(position: position, rotation: rotation, scale: scale);

  /// Vertices coordinates.
  List<double> vertices;

  /// Colors values.
  List<double> colors;

  /// Filter to process object.
  Filter filter;
}
