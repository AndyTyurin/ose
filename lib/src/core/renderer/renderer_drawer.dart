part of ose;

/// Renderer drawer responds for drawing object on a screen.
/// [Renderer] delegates responsability to draw graphics to this.
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
      _drawTarget(object);
      await onPostRender(object);
    }
  }

  /// Draw [target].
  /// It can be an identity or group object.
  void _drawTarget(RenderableObject target) {
    if (target is SceneObjectGroup) {
      _drawGroupObject(target);
    } else {
      _drawIdentityObject(target);
    }
  }

  /// Draw group [target].
  void _drawGroupObject(SceneObjectGroup target) {}

  /// Draw identity [target].
  void _drawIdentityObject(SceneObject target) {
    _prepareShaderProgram(target);
    // tbd @andytyurin uniforms & attributes propagation, drawing will be here.
  }

  /// Prepare target's shader program.
  /// Register if it needed and bind to use.
  void _prepareShaderProgram(SceneObject target) {
    String shaderProgramId = target.getShaderProgramId();

    if (!_spm.isRegistered(shaderProgramId)) {
      // Register a new shader program.
      _spm.register(shaderProgramId, target.getVertexShaderSource(),
          target.getFragmentShaderSource(),
          useCommonDefinitions: target.shouldUseCommonShaderDefinitions(),
          shaderVariables: _shaderVariables);
    }

    // Bind shader program.
    _spm.bind(shaderProgramId);
  }
}
