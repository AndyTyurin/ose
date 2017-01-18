part of ose;

class AmbientLight extends Light {
  SolidColor _color;

  AmbientLight({SolidColor color}) {
    this._color = color ?? new SolidColor.white();
  }

  @override
  void update(double dt) {}

  SolidColor get color => _color;

  void set color(SolidColor color) {
    _color = color;
  }
}
