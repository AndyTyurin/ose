part of ose;

abstract class Filter {
  /// Apply filter.
  /// [gameObject] - use filter of game object.
  /// [scene] - scene where gameobject is placed.
  /// [camera] - active camera.
  void apply(GameObject gameObject, Scene scene, Camera camera);
}
