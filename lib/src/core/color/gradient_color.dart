part of ose;

/// Some scene objects, such as [Shape] can work with vertex colors.
/// Use gradient color to set object's vertex colors. GPU will interpolate
/// your vertex colors in gradients automatically.
///
/// Note, important to know vertex sequence of your object before setting up
/// of colors.
///
/// To create a new gradient color, list of [SolidColor] must be defined in
/// parameters on a constructor. Color list sequence must be same as sequence of
/// object's verticies.
class GradientColor implements Color {
  /// List of solid colors.
  List<SolidColor> _colors;

  /// Create a new gradient color.
  /// [colors] elements sequence must be same as in object which is using
  /// gradient color.
  GradientColor(List<SolidColor> colors) {
    _colors = new List.from(colors);
  }

  @override
  GradientColor clone() {
    return new GradientColor(_colors.map((color) {
      return color.clone();
    }).toList());
  }

  @override
  List<double> toIdentity() {
    List<double> identity = [];
    _colors.forEach((color) {
      identity.addAll(color.toIdentity());
    });
    return identity;
  }

  @override
  Float32List toTypeIdentity() => new Float32List.fromList(toIdentity());

  List<SolidColor> get colors => _colors;
}
