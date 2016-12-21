part of ose;

/// Camera manager manages cameras.
class CameraManager {
  /// Active camera.
  Camera _activeCamera;

  Camera get activeCamera => _activeCamera;

  void set activeCamera(Camera camera) {
    _activeCamera = camera;
  }
}
