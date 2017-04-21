part of ose;

class RenderableObjectGroup extends SceneObject {
  final HashSet<RenderableObject> children;

  RenderableObjectGroup()
      : children = new HashSet();

  bool add(RenderableObject obj) {
    bool added = children.add(obj);

    if (!added) {
      window.console.info(
          "SceneObject#${obj.uuid} added twice to SceneObjectGroup${uuid}");
      return false;
    }
    obj.parent = this;
    return true;
  }

  bool remove(RenderableObject obj) {
    return children.remove(obj);
  }

  void copyFrom(RenderableObject from) {
    transform.copyFrom(from.transform);
  }

  void set actor(SceneObjectActor actor) {
    _actor = actor;
  }

  SceneObjectActor get actor => _actor;
}
