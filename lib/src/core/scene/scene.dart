part of ose;

class Scene {
  /// Unique id.
  String _uuid;

  /// Game objects.
  ///
  /// There are mainly used by renderer to show off on a screen.
  List<GameObject> _objects;

  /// Active camera.
  Camera _camera;

  Scene() {
    _uuid = utils.generateUuid();
    _objects = <GameObject>[];
  }

  /// Add game object to scene.
  void add(GameObject obj) {
    _objects.add(obj);
  }

  /// Remove game object from scene.
  void remove(GameObject obj) {
    _objects.remove(obj);
  }

  List<GameObject> get objects => _objects;

  String get uuid => _uuid;

  Camera get camera => _camera;

  void set camera(Camera camera) {
    _camera = camera;
  }
}
