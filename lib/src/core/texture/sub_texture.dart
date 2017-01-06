part of ose;

class SubTexture extends Texture {
  /// Original texture.
  /// Note, sub texture can't work without original texture.
  final OriginalTexture originalTexture;

  /// Bounding rectangle in percent.
  final Rect boundingRect;

  SubTexture(this.originalTexture, this.boundingRect);

  void set glTexture(webGL.Texture glTexture) {
    originalTexture.glTexture = glTexture;
  }

  webGL.Texture get glTexture => originalTexture?.glTexture;

  ImageElement get image => originalTexture?.image;
}
