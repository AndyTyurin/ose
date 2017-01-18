part of ose;

/// Common interface for colors.
abstract class Color implements TypedIdentity {
  /// Translate colors to double representation.
  List<double> toIdentity();

  /// Clone color.
  Color clone();
}
