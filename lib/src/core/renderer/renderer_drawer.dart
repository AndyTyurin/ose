part of ose;

/// Renderer drawer responds for drawing object on a screen.
/// [Renderer] delegates responsability to draw graphics to this.
class RendererDrawer {
  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  RendererDrawer(this._gl);

  /// Draw [obj].
  draw(SceneObject obj, Scene scene) {
    
  }
}
