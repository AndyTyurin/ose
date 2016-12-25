part of ose;

class OriginalTexture extends Texture {
  /// Texture image.
  final ImageElement image;

  /// WebGL texture.
  webGL.Texture _glTexture;

  OriginalTexture(this.image);

  SubTexture getSubTexture(Rect boundingRect) {
    return new SubTexture(this, boundingRect);
  }

  void set glTexture(webGL.Texture glTexture) {
    if (_glTexture != null) {
      window.console.warn('WebGL texture can be set only once.');
      return;
    }
    _glTexture = glTexture;
  }

  webGL.Texture get glTexture => _glTexture;
}
