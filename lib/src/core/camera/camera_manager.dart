import './camera.dart';

/// Camera manager.
///
/// Each [Scene] has his own camera manager.
/// It manages your cameras to give ability to set an active in runtime.
class CameraManager {
  /// Available cameras.
  Map<String, Camera> _cameras;

  /// Active camera.
  Camera _activeCamera;

  CameraManager() {
    _cameras = <String, Camera>{};
  }

  /// Create a new camera.
  Camera create(String name,
      {left: double,
      right: double,
      bottom: double,
      top: double,
      near: double,
      far: double}) {
    Camera camera = new Camera(left, right, bottom, top, near, far);

    if (_activeCamera == null) _activeCamera = camera;

    return _cameras[name] = camera;
  }

  /// Set active camera.
  ///
  /// Camera must be presented in list of available cameras.
  void setActive(String name) {
    if (_cameras[name] == null)
      throw new StateError("Camera with name \"${name}\" is not found."
          "You need to create it before.");

    _activeCamera = _cameras[name];
  }

  Camera get activeCamera => _activeCamera;

}
