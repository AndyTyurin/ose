part of ose_physic;

class DirectionalRaycaster implements Raycaster {
  Vector2 direction;

  Vector2 position;

  DirectionalRaycaster({this.position, this.direction});

  @override
  List<SceneObject> intersect(List<SceneObject> objects) {
    List<SceneObject> intersected = <SceneObject>[];
    objects.forEach((object) {
      if (_intersectWithObject(object)) {
        intersected.add(object);
      }
    });

    return intersected;
  }

  bool _intersectWithObject(SceneObject object) {
    Vector2 direction2Obj = position.getDirectionTo(object.transform.position);
    return direction2Obj * direction > 0;
  }
}
