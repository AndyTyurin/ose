part of ose;

abstract class Shape extends SceneObject {
  static SolidColor defaultColor = new SolidColor.white();
  static String shaderProgramName = utils.generateUuid();

  /// WebGL colors.
  Float32List _glColors;

  /// WebGL vertices
  Float32List _glVertices;

  /// Shape color.
  Color color;

  /// Previous shape color, to track changes.
  Color _prevColor;

  Shape(Float32List glVertices, {Color color}) : super(glVertices) {
    this.color = color ?? defaultColor;
    _prevColor = defaultColor;
    rebuildColors(true);
  }

  static String getVertexShaderSource() {
    return ""
        "attribute vec4 a_color;"
        "varying vec4 v_color;"
        "void main() {"
        "vec2 pos = vec2(a_position.x, a_position.y) * 2.0 - 1.0;"
        "gl_Position = vec4((u_p * u_v * u_m * vec3(pos, 1.0)).xy, 1.0, 1.0);"
        "v_color = a_color;"
        "}";
  }

  static String getFragmentShaderSource() {
    return ""
        "varying vec4 v_color;"
        "void main() {"
        "gl_FragColor = v_color;"
        "}";
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
  void update(num dt) {
    rebuildColors();
  }

  @override
  void copyFrom(Shape from) {
    super.copyFrom(from);
    color = from.color.clone();
  }

  @override
  String getShaderProgramName() {
    return shaderProgramName;
  }

  Float32List get glVertices => _glVertices;

  Float32List get glColors => _glColors;

  bool get isColorChanged => _prevColor != color;
}
