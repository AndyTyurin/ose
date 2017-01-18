part of ose;

/// Solid color is a smart wrapper of your color, that takes care about
/// color translation to specific representation, such as RGBA, HEX or
/// identity (double list).
///
/// Example of different ways to create a white solid color.
/// By using RGBA representation:
///     new SolidColor([255, 255, 255, 255]);
/// By using HEX representation:
///     new SolidColor.fromHex('ffffffff');
/// By using of double list identity (each parameter from 0 - 1) representation:
///     new SolidColor.fromIdentity([1.0, 1.0, 1.0, 1.0]);
class SolidColor implements Color {
  /// RGBA representation of a color.
  List<int> _rgba;

  SolidColor(List<int> rgba) {
    this._rgba = validateRgba(rgba);
  }

  /// Create a solid color from string HEX code ffaabbccdd (red-green-blue-alpha).
  factory SolidColor.fromHex(String hex) {
    return new SolidColor(hex2rgba(hex));
  }

  /// Creata a solid color from double list identity representation.
  factory SolidColor.fromIdentity(List<double> identity) {
    return new SolidColor(identity2rgba(identity));
  }

  /// Create a solid black color.
  factory SolidColor.black() => new SolidColor([0, 0, 0, 255]);

  /// Create a solid red color.
  factory SolidColor.red() => new SolidColor([255, 0, 0, 255]);

  /// Create a solid green color.
  factory SolidColor.green() => new SolidColor([0, 255, 0, 255]);

  /// Create a solid blue color.
  factory SolidColor.blue() => new SolidColor([0, 0, 255, 255]);

  /// Create a solid yellow color.
  factory SolidColor.yellow() => new SolidColor([255, 0, 255, 255]);

  /// Create a solid white color.
  factory SolidColor.white() => new SolidColor([255, 255, 255, 255]);

  // Return HEX representation of a solid color.
  String toHex() => rgba2hex(_rgba);

  /// Return double list representation of a solid color.
  List<double> toIdentity() => rgba2identity(_rgba);

  /// Clone [SolidColor].
  SolidColor clone() => new SolidColor(_rgba);

  /// Converts RGBA to HEX.
  static String rgba2hex(List<int> rgba) {
    List<int> validRgba = validateRgba(rgba);
    String r = validRgba[0]?.toRadixString(16) ?? '00';
    String g = validRgba[1]?.toRadixString(16) ?? '00';
    String b = validRgba[2]?.toRadixString(16) ?? '00';
    String a = validRgba[3]?.toRadixString(16) ?? '00';
    return "${r}${g}${b}${a}";
  }

  /// Converts RGBA to double list.
  static List<double> rgba2identity(List<int> rgba) {
    List<int> validRgba = validateRgba(rgba);
    return [
      validRgba[0] / 255,
      validRgba[1] / 255,
      validRgba[2] / 255,
      validRgba[3] / 255
    ];
  }

  /// Converts HEX to RGBA.
  static List<int> hex2rgba(String hex) {
    String validatedHex = validateHex(hex);
    return new RegExp("[0123456789ABCDEFabcdef]{2}")
        .allMatches(validatedHex)
        .map((v) {
      return int.parse(v.group(0), radix: 16);
    }).toList();
  }

  /// Converts HEX to double list.
  static List<double> hex2identity(String hex) {
    String validatedHex = validateHex(hex);
    return new RegExp("[0123456789ABCDEFabcdef]{2}")
        .allMatches(validatedHex)
        .map((v) {
      return int.parse(v.group(0), radix: 16) / 255;
    }).toList();
  }

  /// Converts double list to RGBA.
  static List<int> identity2rgba(List<double> identity) {
    List<double> validIdentity = validateIdentity(identity);
    return [
      (validIdentity[0] * 255).toInt(),
      (validIdentity[1] * 255).toInt(),
      (validIdentity[2] * 255).toInt(),
      (validIdentity[3] * 255).toInt()
    ];
  }

  /// Converts double list to HEX.
  static String identity2hex(List<double> identity) {
    List<double> validIdentity = validateIdentity(identity);
    String r = (validIdentity[0] != null)
        ? (validIdentity[0] * 255).toInt().toRadixString(16)
        : '00';
    String g = (validIdentity[1] != null)
        ? (validIdentity[1] * 255).toInt().toRadixString(16)
        : '00';
    String b = (validIdentity[2] != null)
        ? (validIdentity[2] * 255).toInt().toRadixString(16)
        : '00';
    String a = (validIdentity[3] != null)
        ? (validIdentity[3] * 255).toInt().toRadixString(16)
        : '00';
    return "${r}${g}${b}${a}";
  }

  /// Validate RGBA code.
  static List<int> validateRgba(List<int> rgba) {
    if (rgba == null) {
      return [0, 0, 0, 255];
    }
    return [
      (rgba[0] != null) ? max(0, min(255, rgba[0])) : 0,
      (rgba[1] != null) ? max(0, min(255, rgba[1])) : 0,
      (rgba[2] != null) ? max(0, min(255, rgba[2])) : 0,
      (rgba[3] != null) ? max(0, min(255, rgba[3])) : 255
    ];
  }

  /// Validate HEX code.
  static String validateHex(String hex) {
    if (hex == null) {
      return '00000000';
    }
    return (new List<String>.filled(8, '0')..setAll(0, hex.split('').take(8)))
        .join('');
  }

  /// Validate double list.
  static List<double> validateIdentity(List<double> identity) {
    if (identity == null) {
      return [0.0, 0.0, 0.0, 1.0];
    }
    return <double>[
      (identity[0] != null) ? max(0, min(1.0, identity[0])) : 0,
      (identity[1] != null) ? max(0, min(1.0, identity[1])) : 0,
      (identity[2] != null) ? max(0, min(1.0, identity[2])) : 0,
      (identity[3] != null) ? max(0, min(1.0, identity[3])) : 1.0
    ];
  }

  @override
  Float32List toTypeIdentity() => new Float32List.fromList(toIdentity());

  bool operator ==(SolidColor SolidColor) {
    return rgba == SolidColor.rgba;
  }

  List<int> get rgba => _rgba;

  void set rgba(List<int> rgba) {
    _rgba = validateRgba(rgba);
  }

  List<double> get identity => rgba2identity(_rgba);

  String get hex => rgba2hex(_rgba);

  void set alpha(int alpha) {
    _rgba[3] = max(0, min(255, alpha));
  }

  void set r(int r) {
    _rgba[0] = max(0, min(255, r));
  }

  void set g(int g) {
    _rgba[1] = max(0, min(255, g));
  }

  void set b(int b) {
    _rgba[2] = max(0, min(255, b));
  }
}
