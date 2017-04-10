part of ose;

/// Renderer drawer responds for drawing object on a screen.
/// [Renderer] delegates responsability to draw graphics to this.
class RendererDrawer {
  /// WebGL rendering context.
  final webGL.RenderingContext _gl;

  /// Shader program manager is needed to work with shader programs.
  final ShaderProgramManager _spm;

  RendererDrawer(this._gl, this._spm);

  /// Draw objects.
  Future draw(List<SceneObject> objects, Future onRender(SceneObject obj),
      Future onPostRender(SceneObject obj)) async {
    // tbd @andytyurin apply strategy, how to render objects for best perfomance.
    objects.forEach((object) {
      _checkIsTargetProgramPrepared(object);
      await onRender(object);
      _drawTarget(object);
      await onPostRender(object);
    });
  }

  /// Check is [target] object prepared.
  /// Returns [true] if shader program already registered or [false] if not.
  bool _checkIsTargetProgramPrepared(SceneObject target) {
    _spm.isRegistered()
  }

  /// Draw [target].
  /// It can be an identity or group object.
  void _drawTarget(SceneObject target) {
    if (target is SceneObjectGroup) {
      _drawGroupObject(target);
    } else {
      _drawIdentityObject(target);
    }
  }

  /// Draw identity [target].
  void _drawIdentityObject(SceneObject target) {

  }

  /// Draw group [target].
  void _drawGroupObject(SceneObjectGroup target) {

  }
}
