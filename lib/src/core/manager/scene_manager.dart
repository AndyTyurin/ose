part of ose;

/// Scene manager keeps and manages bound scene.
///
class SceneManager {
  /// Active scene which will be used by [Renderer].
  Scene _boundScene;

  /// Scene that will be used next by [Renderer].
  /// By using [set] method, it can be changed on next cycle.
  Scene _stagedScene;

  /// Set a new scene to use.
  /// The new scene will be set on next cycle of rendering.
  bool set(Scene scene) {
    _stagedScene = scene;
  }

  Scene get boundScene => _boundScene;

  Scene set boundScene(Scene scene) {
    _boundScene = scene;
  }

  Scene get stagedScene => _stagedScene;
}
