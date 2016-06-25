part of ose;

abstract class ColorsMixin {
  Float32List _colors;

  /// Set default colors to each vertex.
  void setupDefaultColors(int vertices) {
    var colors = [];
    while(vertices != 0) {
      colors.addAll([0.5, 0.5, 0.5, 1.0]);
      vertices--;
    }
    this._colors = new Float32List.fromList(colors);
  }

  List<double> get colors => _colors;

  set colors(List<double> colors) => _colors = colors;
}