part of ose;

abstract class Filter {
  /// Apply filter.
  /// Use scene, camera & filter implementation to an object.
  void apply(GameObject gameObject, Scene scene, Camera camera);
}
