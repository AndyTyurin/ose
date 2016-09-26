part of ose;

class Sprite extends SceneObject {
  Texture _texture;

  Vector4 _glTextureBounds;

  Float32List _glVertices;
  Float32List _glTextureCoords;

  SpriteFilter filter;

  Sprite({Texture texture}) {
    _glVertices =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    filter = new SpriteFilter();
    setActiveTexture(texture);
  }

  void setActiveTexture(Texture texture) {
    _texture = texture;
  }

  void setActiveSubTexture(SubTexture subTexture) {
    ImageElement textureImg = subTexture.parentTexture.image;
    _texture = subTexture.parentTexture;
    _glTextureBounds = subTexture.boundingRect
        .toIdentityVector4(textureImg.width, textureImg.height);
  }

  @override
  void copyFrom(Sprite from) {
    super.copyFrom(from);
    _texture = from.texture;
  }

  Texture get texture => _texture;

  Vector4 get glTextureBounds => new Vector4(0.0, 0.0, 0.5, 0.5);

  Float32List get glVertices => _glVertices;

  Float32List get glTextureCoords => _glTextureCoords;

  bool get hasTexture => _texture != null;
}
