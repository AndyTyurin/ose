part of ose;

class Camera extends Object with utils.UuidMixin {
  final CameraTransform transform;

  Camera(int width, int height, {num scale, Vector2 position, num rotation})
      : transform = new CameraTransform(width, height,
            position: position, rotation: rotation, scale: scale);
}
