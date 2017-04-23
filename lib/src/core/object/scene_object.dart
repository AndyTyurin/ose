part of ose;

abstract class SceneObject extends Object
    with utils.UuidMixin
    implements ActorOwner {
  final SceneObjectTransform transform;

  /// Parent scene object.
  SceneObject parent;

  /// Actor can manipulate object.
  SceneObjectActor actor;

  SceneObject() : transform = new SceneObjectTransform();

  /// Update object's logic.
  void update(num dt, InputControllers inputControllers) {
    if (actor != null) {
      actor.update(this, inputControllers);
    }
    transform.updateModelMatrix();
  }

  void copyFrom(RenderableObject obj) {
    // tbd @andytyurin make Clonable interface and implementation.
    // actor = obj.actor.clone();
  }
}
