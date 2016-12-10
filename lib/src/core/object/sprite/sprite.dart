part of ose;

class Sprite extends SceneObject {
  Texture _texture;

  Vector4 _glTextureBounds;

  Float32List _glVertices;
  Float32List _glTextureCoords;

  SpriteFilter filter;

  Sprite()
      : super(
            vertices: new Float32List.fromList(
                [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0])) {
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    filter = new SpriteFilter();
  }

  void rebuildCoordinates() {
    ImageElement textureImg = _texture.image;
    int textureWidth = textureImg.width;
    int textureHeight = textureImg.height;
    double aspectRatio = min(1.0 / textureWidth, 1.0 / textureHeight);
    double unitTextureWidth = textureWidth * aspectRatio;
    double unitTextureHeight = textureHeight * aspectRatio;
    double ratioX = 1.0 / unitTextureWidth;
    double ratioY = 1.0 / unitTextureHeight;
    double spriteSizeX = (glTextureBounds.z - glTextureBounds.x) / ratioX;
    double spriteSizeY =
        ((1.0 - glTextureBounds.y) - (1.0 - glTextureBounds.w)) / ratioY;
    double indentX = .5 - spriteSizeX / 2;
    double indentY = .5 - spriteSizeY / 2;

    _glVertices = new Float32List.fromList([
      indentX,
      indentY,
      indentX,
      indentY + spriteSizeY,
      indentX + spriteSizeX,
      indentY,
      indentX + spriteSizeX,
      indentY + spriteSizeY
    ]);

    _glTextureCoords = new Float32List.fromList([
      _glTextureBounds.x,
      _glTextureBounds.y,
      _glTextureBounds.x,
      _glTextureBounds.w,
      _glTextureBounds.z,
      _glTextureBounds.y,
      _glTextureBounds.z,
      _glTextureBounds.w
    ]);
  }

  void setActiveTexture(Texture texture) {
    _texture = texture;
    _glTextureBounds = new Vector4(0.0, 0.0, 1.0, 1.0);
    rebuildCoordinates();
  }

  void setActiveSubTexture(SubTexture subTexture) {
    Texture parentTexture = subTexture.parentTexture;
    ImageElement textureImg = parentTexture.image;
    int width = textureImg.width;
    int height = textureImg.height;
    Vector4 boundingVector = subTexture.boundingRect.toVector4();
    _glTextureBounds = boundingVector
      ..setValues(boundingVector.x / width, 1 - boundingVector.w / height,
          boundingVector.z / width, 1 - boundingVector.y / height);
    texture = parentTexture;
    _texture = texture;
    rebuildCoordinates();
  }

  @override
  void update(num dt) {}

  @override
  void copyFrom(Sprite from) {
    super.copyFrom(from);
    _texture = from.texture;
  }

  Texture get texture => _texture;

  void set texture(Texture texture) {
    _texture = texture;
  }

  webGL.Texture get glTexture => _texture.glTexture;

  Vector4 get glTextureBounds => _glTextureBounds;

  Float32List get glTextureCoords => _glTextureCoords;

  bool get hasTexture => _texture != null;
}
