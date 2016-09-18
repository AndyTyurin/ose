part of ose;

class Texture {
  final ImageElement image;

  bool _isPrepared;

  webGL.Texture _glTexture;

  Texture(ImageElement image) : image = image;

  webGL.Texture get glTexture => _glTexture;

  void set glTexture(webGL.Texture glTexture) {
    if (_glTexture != null) {
      throw new Exception('WebGL texture is already set.');
    }
    _glTexture = glTexture;
  }
}
