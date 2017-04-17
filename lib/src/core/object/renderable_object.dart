part of ose;

abstract class RenderableObject extends Object
    with utils.UuidMixin implements ActorOwner {
  final SceneObjectTransform transform;

  Actor _actor;

  RenderableObject(): transform = new SceneObjectTransform();

  void copyFrom(RenderableObject obj) {
    // tbd @andytyurin make Clonable interface and implementation.
    // actor = obj.actor.clone();
  }

  Actor get actor => _actor;

  void set actor(Actor actor) {
    _actor = actor;
  }
}
