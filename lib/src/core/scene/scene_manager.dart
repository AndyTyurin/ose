import './scene.dart';
import './../camera/camera.dart';

class SceneManager {
  /// Available scenes.
  ///
  /// Only one [Scene] can be an active in same time.
  Map<String, Scene> _scenes;

  /// Active scene.
  Scene _activeScene;

  SceneManager() {
    _scenes = <String, Scene>{};
  }

  Scene create(String name) {
    Scene scene = new Scene();
    return _scenes[name] = scene;
  }

  void setActive(String name) {
    if (_scenes[name] == null)
      throw new StateError("Scene with name \"${name}\" is not found."
          "You need to create it before.");

    _activeScene = _scenes[name];
  }
}