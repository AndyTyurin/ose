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
  Set<SceneObject> _children;

  /// List with lights.
  Set<Light> _lights;

  /// Ambient light.
  AmbientLight _ambientLight;

  Scene()
      : _uuid = utils.generateUuid(),
        _children = new Set(),
        _lights = new Set();

  /// Add a new object to scene.
  void add(dynamic obj) {
    if (obj is Light) {
      _addLight(obj);
    } else {
      _addObject(obj);
    }
  }

  /// Remove object from a scene.
  void remove(dynamic obj) {
    if (obj is Light) {
      _removeLight(obj);
    } else {
      _removeObject(obj);
    }
  }

  void _addObject(SceneObject obj) {
    _children.add(obj);
  }

  void _removeObject(SceneObject obj) {
    _children.remove(obj);
  }

  void _addLight(Light light) {
    if (light is AmbientLight) {
      _ambientLight = light;
    } else {
      _lights.add(light);
    }
  }

  void _removeLight(Light light) {
    if (light is AmbientLight) {
      _ambientLight = null;
    } else {
      _lights.remove(light);
    }
  }

  /// Scene logic handler.
  /// Renderer invokes [update] each tick.
  void update(double dt, CameraManager cameraManager) {}

  String get uuid => _uuid;

  Set<SceneObject> get children => _children;

  Set<Light> get lights => _lights;

  AmbientLight get ambientLight => _ambientLight;
}
