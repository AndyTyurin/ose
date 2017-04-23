part of ose;

class RenderableObjectGroup extends SceneObject {
  final HashSet<SceneObject> children;

  RenderableObjectGroup()
      : children = new HashSet<SceneObject>();

  bool add(SceneObject obj) {
    bool added = children.add(obj);

    if (!added) {
      window.console.info(
          "SceneObject#${obj.uuid} added twice to RenderableObjectGroup${uuid}");
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
}
