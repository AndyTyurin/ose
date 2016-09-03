part of ose;

class Camera {
  /// Unique id.
  final String _uuid;

  /// Transformation.
  CameraTransform _transform;

  Camera(int width, int height, {num scale, Vector2 position, num rotation})
      : _uuid = utils.generateUuid(),
        _transform = new CameraTransform(width, height,
            position: position, rotation: rotation, scale: scale);

  String get uuid => _uuid;

  CameraTransform get transform => _transform;
}
