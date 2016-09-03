part of ose;

class Color {
  List<int> _rgba;

  Color(List<int> rgba) {
    this._rgba = validateRgba(rgba);
  }

  factory Color.fromHex(String hex) {
    return new Color(hex2rgba(hex));
  }

  factory Color.fromIdentity(List<double> identity) {
    return new Color(identity2rgba(identity));
  }

  factory Color.black() => new Color([0, 0, 0, 255]);

  factory Color.red() => new Color([255, 0, 0, 255]);

  factory Color.green() => new Color([0, 255, 0, 255]);

  factory Color.blue() => new Color([0, 0, 255, 255]);

  factory Color.white() => new Color([255, 255, 255, 255]);

  String toHex() => rgba2hex(_rgba);

  List<double> toIdentity() => rgba2identity(_rgba);

  Color clone() => new Color(_rgba);

  static String rgba2hex(List<int> rgba) {
    List<int> validRgba = validateRgba(rgba);
    String r = validRgba[0]?.toRadixString(16) ?? '00';
    String g = validRgba[1]?.toRadixString(16) ?? '00';
    String b = validRgba[2]?.toRadixString(16) ?? '00';
    String a = validRgba[3]?.toRadixString(16) ?? '00';
    return "${r}${g}${b}${a}";
  }

  static List<double> rgba2identity(List<int> rgba) {
    List<int> validRgba = validateRgba(rgba);
    return [
      validRgba[0] / 255,
      validRgba[1] / 255,
      validRgba[2] / 255,
      validRgba[3] / 255
    ];
  }

  static List<int> hex2rgba(String hex) {
    String validatedHex = validateHex(hex);
    return new RegExp("[0123456789ABCDEFabcdef]{2}")
        .allMatches(validatedHex)
        .map((v) {
      return int.parse(v.group(0), radix: 16);
    }).toList();
  }

  static List<double> hex2identity(String hex) {
    String validatedHex = validateHex(hex);
    return new RegExp("[0123456789ABCDEFabcdef]{2}")
        .allMatches(validatedHex)
        .map((v) {
      return int.parse(v.group(0), radix: 16) / 255;
    }).toList();
  }

  static List<int> identity2rgba(List<double> identity) {
    List<double> validIdentity = validateIdentity(identity);
    return [
      (validIdentity[0] * 255).toInt(),
      (validIdentity[1] * 255).toInt(),
      (validIdentity[2] * 255).toInt(),
      (validIdentity[3] * 255).toInt()
    ];
  }

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

  static String validateHex(String hex) {
    if (hex == null) {
      return '00000000';
    }
    return (new List<String>.filled(8, '0')..setAll(0, hex.split('').take(8)))
        .join('');
  }

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

  bool operator ==(Color color) {
    return rgba == color.rgba;
  }

  List<int> get rgba => _rgba;

  void set rgba(List<int> rgba) {
    _rgba = validateRgba(rgba);
  }

  List<double> get identity => rgba2identity(_rgba);

  String get hex => rgba2hex(_rgba);
}
