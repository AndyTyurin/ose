part of ose;

class Camera {
  /// Unique id.
  String _uuid;

  /// Transformation.
  CameraTransform _transform;

  Camera(int width, int height, {num scale, Vector2 position, Vector2 rotation})
      : this._uuid = utils.generateUuid(),
        this._transform = new CameraTransform(width, height,
            position: position, rotation: rotation, scale: scale);

  String get uuid => this._uuid;

  CameraTransform get transform => this._transform;
}
