part of ose;

abstract class RenderableObject extends Object
    with utils.UuidMixin
    implements ActorOwner {
  /// Actor can manipulate object.
  Actor actor;

  /// Update object's logic.
  void update(num dt, InputControllers inputControllers) {
    if (actor != null) {
      actor.update(this, inputControllers);
    }
  }

  void copyFrom(RenderableObject obj) {
    // tbd @andytyurin make Clonable interface and implementation.
    // actor = obj.actor.clone();
  }
}
