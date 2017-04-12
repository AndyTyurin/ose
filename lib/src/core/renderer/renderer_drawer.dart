part of ose;

/// Renderer drawer responds for drawing object on a screen.
/// [Renderer] delegates responsability to draw objects to this.
class RendererDrawer {
  /// WebGL rendering context.
  final webGL.RenderingContext _gl;

  /// Shader program manager is needed to work with shader programs.
  final ShaderProgramManager _spm;

  /// Shader variables will be used when on shaders' source registration.
  /// Each variable will be interpolated through the sources.
  final Map<String, String> _shaderVariables;

  RendererDrawer(this._gl, this._spm, this._shaderVariables);

  /// Draw objects.
  Future draw(
      Iterable<RenderableObject> objects,
      Future onRender(RenderableObject obj),
      Future onPostRender(RenderableObject obj)) async {
    // tbd @andytyurin apply strategy, how to render objects for best perfomance.
    for (RenderableObject object in objects) {
      await onRender(object);
      _drawObject(object);
      await onPostRender(object);
    }
  }

  /// Draw [obj].
  /// It can be an identity or group object.
  void _drawObject(RenderableObject obj) {
    if (obj is SceneObjectGroup) {
      _drawGroupObject(obj);
    } else {
      _drawIdentityObject(obj);
    }
  }

  /// Draw group [obj].
  void _drawGroupObject(SceneObjectGroup obj) {
    obj.children.forEach(_drawIdentityObject);
  }

  /// Draw identity [obj].
  void _drawIdentityObject(SceneObject obj) {
    _prepareShaderProgram(obj);
    _gl.drawArrays(
        webGL.TRIANGLE_STRIP, 0, (obj as dynamic).glVertices.length ~/ 2);
  }

  /// Prepare target's shader program.
  /// Register if it needed and bind to use.
  void _prepareShaderProgram(SceneObject obj) {
    String shaderProgramId = obj.getShaderProgramName();

    if (!_spm.isRegistered(shaderProgramId)) {
      window.console.warn(
          'Can\'t render target by using of shader program with id \'${shaderProgramId}\'');
      return;
    }

    // Bind shader program.
    _spm.bind(shaderProgramId);
  }
}
