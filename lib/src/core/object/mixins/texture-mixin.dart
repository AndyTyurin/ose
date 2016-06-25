part of ose;

abstract class TextureMixin {
  Texture _texture;

  Texture get texture => _texture;

  set texture(Texture texture) => _texture = texture;
}