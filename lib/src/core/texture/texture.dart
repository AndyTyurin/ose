part of ose;

abstract class Texture extends Object with utils.UuidMixin {
  operator ==(Texture other) {
    return this.uuid == other.uuid;
  }

  ImageElement get image;

  void set glTexture(webGL.Texture glTexture);

  webGL.Texture get glTexture;
}
