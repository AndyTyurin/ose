part of ose;

abstract class Shape extends GameObject {
  static SolidColor defaultColor = new SolidColor(new Color.white());

  Float32List _glColors;

  ComplexColor color;

  ComplexColor _prevColor;

  ShapeFilter filter;

  Shape({@required Float32List vertices, ComplexColor color})
      : super(vertices: vertices) {
    this.color = color ?? defaultColor;
    _prevColor = defaultColor;
    filter = new ShapeFilter();
    rebuildColors(true);
  }

  void rebuildColors([bool force]) {
    if (force || isColorChanged) {
      ComplexColor complexColor = color ?? defaultColor;
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
  void copyFrom(Shape from) {
    super.copyFrom(from);
    color = from.color.clone();
  }

  Float32List get glColors => _glColors;

  bool get isColorChanged => _prevColor != color;
}
