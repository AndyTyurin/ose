part of ose;

/// Scene is a playground for your objects.
///
/// There can be defined specific logic for your scene by overriding [update]
/// and [perObjectUpdate] methods.
///
/// Note: [Actor] has access to the [Scene] and can invoke different public
/// methods of it while updating.
class Scene extends Object with utils.UuidMixin implements ActorOwner {
  /// List with scene objects.
  Set<RenderableObject> _children;

  /// List with lights.
  Set<Light> _lights;

  /// Camera manager to manage cameras.
  CameraManager _cameraManager;

  /// Global ambient light.
  AmbientLight _ambientLight;

  /// Scene actor.
  SceneActor _actor;

  Scene()
      : _children = new Set(),
        _lights = new Set();

  /// Add a new object to scene.
  /// [obj] can be instance of [Light] or [RenderableObject].
  void add(dynamic obj) {
    if (obj is Light) {
      _addLight(obj);
    } else if (obj is RenderableObject) {
      _addRenderableObject(obj);
    } else {
      throw new ArgumentError("Trying to add wrong type object to scene");
    }
  }

  /// Remove object from a scene.
  /// [obj] can be instance of [Light] or [RenderableObject].
  void remove(dynamic obj) {
    if (obj is Light) {
      _removeLight(obj);
    } else if (obj is RenderableObject) {
      _removeRenderableObject(obj);
    } else {
      throw new ArgumentError("Trying to remove wrong type object from scene");
    }
  }

  void _addRenderableObject(RenderableObject obj) {
    _children.add(obj);
  }

  void _removeRenderableObject(RenderableObject obj) {
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

  /// Update scene's logic.
  void update(double dt) {}

  /// Per children object update handler.
  void perObjectUpdate(double dt, RenderableObject obj) {
  }

  Set<SceneObject> get children => _children;

  Set<Light> get lights => _lights;

  AmbientLight get ambientLight => _ambientLight;

  CameraManager get cameraManager => _cameraManager;

  SceneActor get actor => _actor;

  void set actor(SceneActor actor) {
    _actor = actor;
  }
}
