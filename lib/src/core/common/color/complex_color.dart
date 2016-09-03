part of ose;

abstract class ComplexColor {
  List<Color> colors;

  ComplexColor(List<Color> colors) {
    this.colors = colors;
  }

  ComplexColor clone();

  bool operator ==(ComplexColor other) => colors == other.colors;

  List<double> toIdentity() {
    List<double> identityList = <double>[];
    for (Color color in colors) {
      identityList.addAll(color.toIdentity());
    }
    return identityList;
  }
}
