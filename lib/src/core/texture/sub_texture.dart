part of ose;

class SubTexture {
  final Texture parentTexture;

  final Rect boundingRect;

  SubTexture(Texture parentTexture, Rect boundingRect)
      : parentTexture = parentTexture,
        boundingRect = boundingRect;
}
