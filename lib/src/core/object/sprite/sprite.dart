part of ose;

class Sprite extends SceneObject {
  Texture _texture;

  Vector4 _glTextureBounds;

  Float32List _glVertices;
  Float32List _glTextureCoords;

  SpriteFilter filter;

  Sprite() {
    // _glVertices =
    //     new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    filter = new SpriteFilter();
  }

  void rebuildCoordinates() {
    ImageElement textureImg = _texture.image;
    int width = textureImg.width;
    int height = textureImg.height;
    double ratio = min(1.0 / width, 1.0 / height);
    double identityWidth = width * ratio;
    double identityHeight = height * ratio;
    double indentWidth = (1.0 - identityWidth) / 2;
    double indentHeight = (1.0 - identityHeight) / 2;
    double boundsIndentWidth, boundsIndentHeight;

    if (_glTextureBounds.z >= 0.5) {
      boundsIndentWidth = (0.5 - _glTextureBounds.x).abs() +
          (_glTextureBounds.z - _glTextureBounds.x) / 2;
    } else {
      boundsIndentWidth = (0.5 - _glTextureBounds.z).abs() +
          (_glTextureBounds.z - _glTextureBounds.x) / 2;
    }
    // TODO: Height computed wrong.
    if (_glTextureBounds.y >= 0.5) {
      boundsIndentHeight = (1.0 - _glTextureBounds.w).abs() +
          (_glTextureBounds.y - _glTextureBounds.w) / 2;
    } else {
      boundsIndentHeight = (0.5 - _glTextureBounds.y).abs() +
          (_glTextureBounds.y - _glTextureBounds.w) / 2;
    }


    _glVertices = new Float32List.fromList([
      indentWidth + boundsIndentWidth,
      indentHeight + boundsIndentHeight,
      indentWidth + boundsIndentWidth,
      indentHeight + identityHeight + boundsIndentHeight,
      indentWidth + identityWidth + boundsIndentWidth,
      indentHeight + boundsIndentHeight,
      indentWidth + identityWidth + boundsIndentWidth,
      indentHeight + identityHeight + boundsIndentHeight
    ]);

    print(_glVertices);
  }

  void setActiveTexture(Texture texture) {
    _texture = texture;
    _glTextureBounds = new Vector4(0.0, 0.0, 1.0, 1.0);
    rebuildCoordinates();
  }

  void setActiveSubTexture(SubTexture subTexture) {
    _texture = subTexture.parentTexture;
    ImageElement textureImg = _texture.image;
    int width = textureImg.width;
    int height = textureImg.height;
    Vector4 boundingVector = subTexture.boundingRect.toVector4();
    _glTextureBounds = boundingVector
      ..setValues(boundingVector.x / width, 1 - boundingVector.w / height,
          boundingVector.z / width, 1 - boundingVector.y / height);
    print(_glTextureBounds);
    rebuildCoordinates();
  }

  @override
  void copyFrom(Sprite from) {
    super.copyFrom(from);
    _texture = from.texture;
  }

  Texture get texture => _texture;

  webGL.Texture get glTexture => _texture.glTexture;

  Vector4 get glTextureBounds => _glTextureBounds;

  Float32List get glVertices => _glVertices;

  Float32List get glTextureCoords => _glTextureCoords;

  bool get hasTexture => _texture != null;
}
