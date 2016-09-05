part of ose;

/// Abstract renderer event.
/// Is derived by other events of the renderer.
abstract class RendererEvent {
  /// [Renderer] in use.
  Renderer renderer;

  /// Unique identifier.
  String _uuid;

  RendererEvent(this.renderer) : this._uuid = utils.generateUuid();

  String get uuid => _uuid;
}

/// Start event.
/// Note: see [onStart] method.
class StartEvent extends RendererEvent {
  StartEvent(Renderer renderer) : super(renderer);
}

/// Stop event.
/// Note: see [onStop] method.
class StopEvent extends RendererEvent {
  StopEvent(Renderer renderer) : super(renderer);
}

/// Render event.
/// Note: see [onRender] method.
class RenderEvent extends RendererEvent {
  /// [Scene] in use.
  Scene scene;

  /// [Camera] in use.
  Camera camera;

  RenderEvent(this.scene, this.camera, Renderer renderer) : super(renderer);
}

/// Post render event.
/// Note: see [onPostRender] method.
class PostRenderEvent extends RenderEvent {
  PostRenderEvent(Scene scene, Camera camera, Renderer renderer)
      : super(scene, camera, renderer);
}

/// Object render event.
/// Note: see [onRenderEvent] method.
class ObjectRenderEvent extends RenderEvent {
  /// [SceneObject] in use.
  SceneObject gameObject;

  ObjectRenderEvent(
      this.gameObject, Scene scene, Camera camera, Renderer renderer)
      : super(scene, camera, renderer);
}

/// Object post render event.
/// Note: see [onPostRenderEvent] method.
class ObjectPostRenderEvent extends ObjectRenderEvent {
  ObjectPostRenderEvent(
      SceneObject sceneObject, Scene scene, Camera camera, Renderer renderer)
      : super(sceneObject, scene, camera, renderer);
}
