part of ose;

class PointLight extends Light {
  Vector2 _position;

  Vector3 _falloff;

  SolidColor _color;

  PointLight({Vector2 position, SolidColor color, Vector3 falloff}) {
    this._position = position ?? new Vector2.zero();
    this._falloff = falloff ?? new Vector3(.75, 3.0, 20.0);
    this._color = color ?? new SolidColor.white();
  }

  Vector2 get position => _position;

  void set position(Vector2 position) {
    _position = position;
  }

  Vector3 get falloff => _falloff;

  void set falloff(Vector3 falloff) {
    _falloff = falloff;
  }

  SolidColor get color => _color;

  void set color(SolidColor color) {
    _color = color;
  }
}
