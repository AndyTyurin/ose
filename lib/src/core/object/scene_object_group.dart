part of ose;

class SceneObjectGroup extends RenderableObject {
  final HashSet<SceneObject> children;

  SceneObjectGroup()
      : children = new HashSet();

  bool add(SceneObject obj) {
    bool added = children.add(obj);

    if (!added) {
      window.console.info(
          "SceneObject#${obj.uuid} added twice to SceneObjectGroup${uuid}");
      return false;
    }
    obj.parent = this;
    return true;
  }

  bool remove(SceneObject obj) {
    return children.remove(obj);
  }

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }

  void set actor(SceneObjectActor actor) {
    _actor = actor;
  }

  SceneObjectActor get actor => _actor;
}
