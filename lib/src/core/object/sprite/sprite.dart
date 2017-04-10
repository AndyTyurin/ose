part of ose;

class Sprite extends SceneObject {
  static String _spriteClassUuid = utils.generateUuid();

  Texture _texture;

  Texture _normalMapTexture;

  Vector4 _glTextureBounds;

  Float32List _glVertices;

  Float32List _glTextureCoords;

  Sprite() {
    _glVertices =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
  }

  void _rebuildCoordinates() {
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

  void _setOriginalTexture(OriginalTexture texture) {
    _texture = texture;
    _glTextureBounds = new Vector4(0.0, 0.0, 1.0, 1.0);
    _rebuildCoordinates();
  }

  void _setSubTexture(SubTexture texture) {
    OriginalTexture originalTexture = texture.originalTexture;
    ImageElement textureImg = originalTexture.image;
    int width = textureImg.width;
    int height = textureImg.height;
    Vector4 boundingVector = texture.boundingRect.toVector4();
    _glTextureBounds = boundingVector
      ..setValues(boundingVector.x / width, 1 - boundingVector.w / height,
          boundingVector.z / width, 1 - boundingVector.y / height);
    _texture = texture;
    _rebuildCoordinates();
  }

  @override
  void copyFrom(Sprite from) {
    super.copyFrom(from);
    _texture = from.texture;
  }

  Texture get texture => _texture;

  Texture get colorMap => _texture;

  void set texture(Texture texture) {
    if (texture is OriginalTexture) {
      _setOriginalTexture(texture);
    } else if (texture is SubTexture) {
      _setSubTexture(texture);
    }
  }

  void set colorMap(Texture texture) {
    this.texture = texture;
  }

  Texture get normalMap => _normalMapTexture;

  void set normalMap(Texture texture) {
    _normalMapTexture = texture;
  }

  webGL.Texture get glTexture => _texture.glTexture;

  webGL.Texture get glNormalMap => _normalMapTexture.glTexture;

  Vector4 get glTextureBounds => _glTextureBounds;

  Float32List get glTextureCoords => _glTextureCoords;

  Float32List get glVertices => _glVertices;

  bool get hasTexture => _texture != null;

  @override
  String getFragmentShaderSource() {
    // TODO: implement getFragmentShaderSource
  }

  @override
  String getShaderProgramId() {
    return _spriteClassUuid;
  }

  @override
  String getVertexShaderSource() {
    // TODO: implement getVertexShaderSource
  }

  @override
  bool shouldUseCommonShaderDefinitions() {
    return true;
  }
}
