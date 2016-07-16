part of ose;

class SceneManager<T extends Scene> {
  /// Active scene.
  /// Scene that is used by renderer right now.
  T _scene;

  /// List of cached scenes.
  /// It could be used when grabbing specific scene and setting up as an active.
  Map<String, T> scenes;

  SceneManager() : this.scenes = <String, T>{};

  set active(T scene) => this._scene = scene;

  T get active => this._scene;
}
