part of ose;

class DirectionalLight extends Light {
  Vector2 _direction;

  Vector2 _position;

  SolidColor _color;

  DirectionalLight({Vector2 position, Vector2 direction, SolidColor color}) {
    this._direction = direction ?? Vector2.Y_AXIS.clone();
    this._color = color ?? new SolidColor.white();
    this._position = position ?? new Vector2.zero();
  }

  @override
  void update(double dt) {}

  Vector2 get direction => _direction;

  void set direction(Vector2 direction) {
    _direction = direction;
  }

  SolidColor get color => _color;

  void set color(SolidColor color) {
    _color = color;
  }

  Vector2 get position => _position;
}
