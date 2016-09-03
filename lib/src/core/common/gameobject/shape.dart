part of ose;

/// Shape is abstract-level implementation of the [GameObject].
abstract class Shape extends GameObject {
  ComplexColor _color;

  ComplexColor _prevColor;

  /// Filter to process object.
  Filter filter;

  Shape() {
    _color = new SolidColor(new Color.white());
    _prevColor = new SolidColor(new Color.white());
  }

  @mustCallSuper
  void rebuildColors([bool force]) {
    _prevColor = color.clone();
  }

  set color(ComplexColor color) {
    _color = color;
  }

  ComplexColor get color => _color;

  bool get isColorsChanged => _prevColor != _color;
}
