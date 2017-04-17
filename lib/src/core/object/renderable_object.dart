part of ose;

abstract class RenderableObject extends Object
    with utils.UuidMixin implements ActorOwner {

  Actor _actor;

  /// Update object's logic.
  /// Implement to define specific.
  void update(num dt) {
    actor.update(dt);
  }

  void _updateActor(num dt) {
    if (actor != null) {
      // tdb @andytyurin get around actors [Scene] argument, is it really need?
      if (actor is ControlActor) {
        actor.update(sceneObject, _managers.ioManager);
      } else {
        actor.update(sceneObject);
      }
    }
  }

  void copyFrom(RenderableObject obj) {
    // tbd @andytyurin make Clonable interface and implementation.
    // actor = obj.actor.clone();
  }

  Actor get actor => _actor;

  void set actor(Actor actor) {
    _actor = actor;
  }
}
