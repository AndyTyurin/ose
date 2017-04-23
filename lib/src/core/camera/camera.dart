part of ose;

/// 2D plane top-view camera.
/// Clips and shows objects in a scene.
///
/// Look at [Camera.transform] to get know how to rotate, translate or set camera.
class Camera extends Object with utils.UuidMixin {
  /// Takes care about how to place camera in a world coordinates.
  /// Can be used in camera translation, rotation, scaling.
  final CameraTransform transform;

  /// Create a new camera, where
  /// [width] - display width (commonly canvas or screen width),
  /// [height] - display height (commonly canvas or screen height),
  /// [scale] - scale factor, 1.0 is normal, 2.0 double sized,
  /// [position] - camera position in x, y,
  /// [rotation] - camera rotation in radians.
  Camera(int width, int height, {num scale, Vector2 position, num rotation})
      : transform = new CameraTransform(width, height,
            position: position, rotation: rotation, scale: scale);

  /// Update camera's matrices.
  void update() {
    transform.updateProjectionMatrix();
    transform.updateViewMatrix();
  }
}
