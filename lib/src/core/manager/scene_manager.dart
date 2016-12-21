part of ose;

/// Scene manager manages scenes.
class SceneManager {
  /// Active scene.
  Scene _activeScene;

  Scene get activeScene => _activeScene;

  void set activeScene(Scene scene) {
    _activeScene = scene;
  }
}
