part of ose;

class Texture {
  final ImageElement image;

  webGL.Texture _glTexture;

  Texture(ImageElement image) : image = image;

  operator ==(Texture other) {
    return image == other.image && _glTexture == other.glTexture;
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
