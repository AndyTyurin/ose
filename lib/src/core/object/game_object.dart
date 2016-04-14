import './../transform/transform.dart';
import './../material/material.dart';
import './../material/basic_material.dart';

class GameObject {
  /// Transformation.
  Transform transform;

  /// Applied material.
  Material _material;

  /// Children game objects.
  List<GameObject> _children;

  GameObject({Material material, Transform transform}) {
    this.transform = (transform == null) ? new Transform() : transform;
    _material = (material == null) ? new BasicMaterial() : material;
  }

  /// Add game object as a child.
  void add(GameObject obj) {
    // todo: implement.
  }

  /// Remove game object from children.
  void remove(GameObject obj) {
    // todo: implement.
  }
}
