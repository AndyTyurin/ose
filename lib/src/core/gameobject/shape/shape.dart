part of ose_webgl;

abstract class Shape extends ose.Shape {
  /// Vertices coordinates.
  Float32List _glVertices;

  /// Colors values.
  Float32List _glColors;

  Shape({Float32List vertices, ose.ComplexColor color})
      : _glVertices = vertices,
        _glColors = color.toIdentity() {
    filter = new ShapeFilter();
  }

  @override
  void rebuildColors([bool force]) {
    if (force || isColorsChanged) {
      ose.ComplexColor complexColor =
          color ?? new ose.SolidColor(new ose.Color.white());
      List<double> identityColors = complexColor.toIdentity();
      int numOfMissedColors =
          _glVertices.length ~/ 2 - identityColors.length ~/ 4;

      if (complexColor is ose.GradientColor) {
        if (numOfMissedColors > 0) {
          for (int i = 0; i < numOfMissedColors; i++) {
            identityColors.addAll([1.0, 1.0, 1.0, 1.0]);
          }
        } else if (numOfMissedColors < 0) {
          identityColors = identityColors.getRange(0, identityColors.length + numOfMissedColors * 4);
        }
      } else if (complexColor is ose.SolidColor) {
        if (numOfMissedColors > 0) {
          for (int i = 0; i < numOfMissedColors; i++) {
            identityColors.addAll(identityColors.getRange(0, 4));
          }
        }
      }
      
      _glColors = new Float32List.fromList(identityColors);
      super.rebuildColors();
    }
  }

  @override
  void copyFrom(Shape from) {
    super.copyFrom(from);
    _glVertices = new Float32List.fromList(from._glVertices);
    color = from.color.clone();
  }

  Float32List get glVertices => _glVertices;

  Float32List get glColors => _glColors;
}
