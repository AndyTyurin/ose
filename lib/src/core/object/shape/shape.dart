part of ose;

/// Common abstract class is needed to describe our shapes, such as
/// [Triangle], [Rectangle], [Circle].
abstract class Shape extends SceneObject {
  static SolidColor defaultColor = new SolidColor.white();

  /// WebGL colors.
  Float32List _glColors;

  /// Shape color.
  Color color;

  /// Previous shape color.
  /// It's needed to track changes.
  Color _prevColor;

  Shape({@required Float32List vertices, Color color})
      : super(vertices: vertices) {
    this.color = color ?? defaultColor;
    _prevColor = defaultColor;
    rebuildColors(true);
  }

  /// Rebuild colors.
  /// Method will be invoked automatically by renderer on shape color change.
  void rebuildColors([bool force]) {
    if (force || isColorChanged) {
      Color complexColor = color ?? defaultColor;
      List<double> identityColors = complexColor.toIdentity();
      int numOfMissedColors =
          glVertices.length ~/ 2 - identityColors.length ~/ 4;

      if (complexColor is GradientColor) {
        if (numOfMissedColors > 0) {
          for (int i = 0; i < numOfMissedColors; i++) {
            identityColors.addAll([1.0, 1.0, 1.0, 1.0]);
          }
        } else if (numOfMissedColors < 0) {
          identityColors = identityColors.getRange(
              0, identityColors.length + numOfMissedColors * 4);
        }
      } else if (complexColor is SolidColor) {
        if (numOfMissedColors > 0) {
          for (int i = 0; i < numOfMissedColors; i++) {
            identityColors.addAll(identityColors.getRange(0, 4));
          }
        }
      }

      _glColors = new Float32List.fromList(identityColors);
      _prevColor = color.clone();
    }
  }

  @override
  void update(num dt) {}

  @override
  void copyFrom(Shape from) {
    super.copyFrom(from);
    color = from.color.clone();
  }

  Float32List get glColors => _glColors;

  bool get isColorChanged => _prevColor != color;
}
