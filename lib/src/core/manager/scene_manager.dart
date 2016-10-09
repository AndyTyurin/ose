part of ose;

class SceneManager {
  Scene _activeScene;

  Scene get activeScene => _activeScene;

  void set activeScene(Scene scene) {
    _activeScene = scene;
  }
}
