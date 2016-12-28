part of ose;

class SceneObjectGroup extends SceneObject {
  final HashSet<SceneObject> children;

  SceneObjectGroup({SceneObjectTransform transform})
      : super(transform: transform),
        children = new HashSet();

  void add(SceneObject obj) {
    children.add(obj);
    obj.parent = this;
  }

  void addAll(List<SceneObject> objects) {
    objects.forEach(add);
  }

  void remove(SceneObject obj) {
    children.remove(obj);
  }

  void update(num dt) {}

  void copyFrom(SceneObject from) {
    transform.copyFrom(from.transform);
  }
}
