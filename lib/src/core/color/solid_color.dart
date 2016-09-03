part of ose;

class SolidColor extends ComplexColor {
  SolidColor(Color color) : super([color]);

  @override
  SolidColor clone() {
    return new SolidColor(colors[0].clone());
  }
}
