part of ose;

/// Actor is logic controller for entities.
/// It knows about bound scene and controlled object.
///
/// Implement [Actor.update] to take care about how to update scene object.
abstract class Actor {
  /// Update actor.
  /// Invoked each tick by renderer.
  /// Needed to control scene object.
  void update(Scene scene, SceneObject sceneObject);
}
