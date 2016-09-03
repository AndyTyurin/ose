part of ose;

class GradientColor extends ComplexColor {
  GradientColor(List<Color> colors) : super(colors);

  @override
  GradientColor clone() {
    return new GradientColor(colors.map((color) {
      return color.clone();
    }).toList());
  }
}
