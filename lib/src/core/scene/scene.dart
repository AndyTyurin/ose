part of ose;

/// Scene is a storage for objects.
/// Each tick, renderer gets list of those objectskept in scene and render them.
///
/// Additional logic can be put to scene, for example public methods to handle
/// scene state or objects are placed on it.
/// Use [Scene.update] method to reach that goals.
///
/// Note: [Actor] has access to the [Scene] and can invoke different public
/// methods of it in different cases.
///
/// For example:
/// You have your own [Scene] and wants to handle inputs.
/// As a first you will write implementation of [ControlActor], then you can
/// write implementation of your [Scene] objects and describe public methods
/// that will set your camera to follow to your player object.
/// It's not hard to make, you can set follow state to the camera and then
/// handle it inside [Scene.update] method.
class Scene {
  /// Unique id.
  String _uuid;

  /// List with scene objects.
  List<SceneObject> _children;

  Scene()
      : _uuid = utils.generateUuid(),
        _children = <SceneObject>[];

  /// Add a new object to scene.
  void add(SceneObject obj) {
    _children.add(obj);
  }

  /// Remove object from a scene.
  void remove(SceneObject obj) {
    _children.remove(obj);
  }

  /// Scene logic handler.
  /// Renderer invokes [update] each tick.
  void update(double dt, CameraManager cameraManager) {}

  String get uuid => _uuid;

  List<SceneObject> get children => _children;
}
