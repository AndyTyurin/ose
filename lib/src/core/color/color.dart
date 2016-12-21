part of ose;

/// Common interface for colors.
abstract class Color {
  /// Translate colors to double representation.
  List<double> toIdentity();

  /// Clone color.
  Color clone();
}
