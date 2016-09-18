part of ose;

class Sprite extends SceneObject {
  Texture _texture;

  Float32List _glVertices;
  Float32List _glTextureCoords;

  SpriteFilter filter;

  Sprite({Texture texture}) {
    _texture = texture;
    _glVertices =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
    filter = new SpriteFilter();
  }

  Float32List get glVertices => _glVertices;

  Float32List get glTextureCoords => _glTextureCoords;

  bool get hasTexture => _texture != null;
}
