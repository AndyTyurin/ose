part of ose;

class Texture extends Object with utils.UuidMixin {
  final ImageElement image;

  webGL.Texture _glTexture;

  Texture(ImageElement image) : image = image;

  operator ==(Texture other) {
    return this.uuid == other.uuid;
  }

  webGL.Texture get glTexture => _glTexture;

  void set glTexture(webGL.Texture glTexture) {
    if (_glTexture != null) {
      throw new Exception('WebGL texture is already set.');
    }
    _glTexture = glTexture;
  }

  SubTexture createSubTexture(Rect boundingRect) {
    return new SubTexture(this, boundingRect);
  }
}
