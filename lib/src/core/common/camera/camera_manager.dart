part of ose;

class CameraManager<T extends Camera> {
  /// Active camera.
  /// Camera that is used by renderer right now.
  T _camera;

  /// List of cached cameras.
  /// It could be used to get specific camera and setting up as an active.
  Map<String, T> cameras;

  CameraManager() : this.cameras = <String, T>{};

  set active(T camera) => this._camera = camera;

  T get active => this._camera;
}
