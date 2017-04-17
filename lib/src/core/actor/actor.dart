part of ose;

abstract class Actor extends Object with utils.UuidMixin {
  void update(ActorOwner owner, IOTools tools);
}
