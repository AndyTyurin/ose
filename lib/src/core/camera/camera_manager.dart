part of ose;

/// Camera manager.
///
/// Register new cameras, bind which is needed to use, give opportunity to
/// switch between camera whenever you want.
///
/// Camera can be bound only once per rendering cycle, to modify already
/// registered cameras, use [get] method, to retrive already bound use
/// [boundCamera] getter instead.
class CameraManager {
  /// Registration "list" with available cameras with unique identifiers.
  final Map<String, Camera> _cameras;

  /// Bound camera is used while rendering.
  Camera _boundCamera;

  /// Camera that will be set in new iteration of rendering.
  Camera _stagedCamera;

  CameraManager() : _cameras = <String, Camera>{};

  /// Update bound camera.
  /// If there is a staged camera set before, it will be set as bound.
  void update() {
    if (_stagedCamera != null) {
      _boundCamera = _stagedCamera;
      _stagedCamera = null;
    }
    if (_boundCamera != null) {
      // Update camera's projection & view matrices.
      _boundCamera.update();
    }
  }

  /// Set camera with identifier [name] to be an active in next cycle.
  bool bind(String name) {
    if (!isRegistered(name)) return false;
    _stagedCamera = _cameras[name];
    return true;
  }

  /// Register camera in manager with unique identifier [name] or replace
  /// already registered by new once.
  void register(String name, Camera camera) {
    _cameras[name] = camera;
    // Bind first camera automatically.
    if (_cameras.keys.length == 1) {
      bind(name);
    }
  }

  /// Check is camera [name] is registered in manager.
  bool isRegistered(String name) {
    return _cameras.containsKey(name);
  }

  /// Remove camera with [name] identifier from registration list.
  void remove(String name) {
    _cameras.remove(name);
  }

  /// Get camera with [name] identifier from registration list.
  Camera get(String name) {
    return _cameras[name];
  }

  Camera get boundCamera => _boundCamera;
}
