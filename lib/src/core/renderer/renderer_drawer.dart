part of ose;

/// Renderer drawer responds for drawing object on a screen.
/// [Renderer] delegates responsability to draw objects to this.
class RendererDrawer {
  /// WebGL rendering context.
  final webGL.RenderingContext _gl;

  /// Shader program manager is needed to work with shader programs.
  final ShaderProgramManager _spm;

  RendererDrawer(this._gl, this._spm);

  /// Draw objects.
  Future draw(
      Iterable<SceneObject> objects,
      Future onDraw(SceneObject obj),
      Future onPostDraw(SceneObject obj)) async {
    // tbd @andytyurin apply strategy, how to render objects for best perfomance.
    for (SceneObject object in objects) {
      await onDraw(object);
      _drawObject(object);
      await onPostDraw(object);
    }
  }

  /// Draw [obj].
  /// It can be an identity or group object.
  void _drawObject(SceneObject obj) {
    if (obj is RenderableObjectGroup) {
      _drawGroupObject(obj);
    } else {
      _drawIdentityObject(obj);
    }
  }

  /// Draw group [obj].
  void _drawGroupObject(RenderableObjectGroup obj) {
    obj.children.forEach(_drawIdentityObject);
  }

  /// Draw identity [obj].
  void _drawIdentityObject(RenderableObject obj) {
    _prepareShaderProgram(obj);
    _gl.drawArrays(
        webGL.TRIANGLE_STRIP, 0, (obj as dynamic).glVertices.length ~/ 2);
  }

  /// Prepare target's shader program.
  /// Register if it needed and bind to use.
  void _prepareShaderProgram(RenderableObject obj) {
    String shaderProgramId = obj.getShaderProgramName();

    if (!_spm.isRegistered(shaderProgramId)) {
      window.console.warn(
          'Can\'t render target by using of sha der program with id \'${shaderProgramId}\'');
      return;
    }

    // Bind shader program.
    _spm.bind(shaderProgramId);
  }
}
