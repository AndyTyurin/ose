part of ose;

class CameraManager {
  Camera _activeCamera;

  Camera get activeCamera => _activeCamera;

  void set activeCamera(Camera camera) {
    _activeCamera = camera;
  }
}
