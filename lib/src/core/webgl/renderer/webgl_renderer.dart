part of ose_webgl;

// TODO: Write webgl is not supported callback.
// TODO: Write overriding of rendering.

class WebGLRenderer extends ose.Renderer {
  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  /// Create WebGL renderer.
  ///
  /// [CanvasElement] - use already defined canvas.
  /// [width] - canvas & viewport width.
  /// [height] - canvas & viewport height.
  /// [transparent] - use alpha, [true] by default.
  /// [antialias] - use antialias, [true] by default.
  /// [preserveDrawingBuffer] - Do not clear drawing buffer, [false] by default.
  WebGLRenderer(
      {CanvasElement canvas,
      int width,
      int height,
      num pixelRatio: 1.0,
      int fps: 60,
      bool autoResize: false,
      bool transparent: false,
      bool mask: true,
      bool color: 0x000000,
      bool clear: true,
      bool antialias: false})
      : super(
            canvas: canvas,
            width: width,
            height: height,
            pixelRatio: pixelRatio,
            fps: fps,
            autoResize: autoResize,
            transparent: transparent,
            mask: mask,
            color: color,
            clear: clear,
            antialias: antialias) {
    this._gl = this._initWebGL();
  }

  /// See [ose.Renderer.renderScene].
  @override
  Future renderScene(ose.Scene scene, ose.Camera camera) async {
    // Create clear mask.
    int clearMask = 0x00;

    // Mask to clear color buffer.
    if (this.useClear) {
      clearMask |= webGL.COLOR_BUFFER_BIT;
    }

    // Mask to clear stencil buffer.
    if (this.useMask) {
      clearMask |= webGL.STENCIL_BUFFER_BIT;
    }

    // Clear buffers by defined mask.
    if (clearMask > 0x00) {
      gl.clear(clearMask);
    }

    super.renderScene(scene, camera);
  }

  /// See [ose.Renderer.renderObject].
  @override
  Future renderObject(
      ose.GameObject gameObject, ose.Scene scene, ose.Camera camera) async {
    super.renderObject(gameObject, scene, camera);

    if (this.useMask) {
      /// TODO: Check how could be use mask manager.
      /// this.maskManager(gameObject, maskObject, MaskManager.intersect);
      /// this.maskManager(gameObject, maskObject, MaskManager.subtract);
      /// this.maskManager.subtract(gameObject, maskObject);
      /// this.maskManager.intersect(gameObject, maskObject);
    }

    // TODO: Write basic filter interface for gameobjects.
    // TODO: Shoud I use mixins to set common class attributes?

    // Draw object.
    //this.gl.drawArrays(webGL.TRIANGLE_STRIP, 0,
    //((obj as VerticesMixin).vertices.length ~/ 2));
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext() {
    return this.canvas.getContext3d(
        alpha: this.useTransparent,
        premultipliedAlpha: this.useTransparent,
        antialias: this.useAntialias,
        stencil: this.useMask,
        preserveDrawingBuffer: this.useClear);
  }

  /// Initialize WebGL.
  webGL.RenderingContext _initWebGL() {
    webGL.RenderingContext gl = this._createRenderingContext();

    if (gl == null) throw 'WebGL is not supported';

    // Disable depth.
    gl.disable(webGL.DEPTH_TEST);

    // Enable stencil buffer usage.
    if (this.useMask) {
      gl.enable(webGL.STENCIL_TEST);
    }

    // Enable blending.
    if (this.useTransparent) {
      gl.enable(webGL.BLEND);
      gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
    }

    // Clear with color.
    if (this.useClear) {
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      gl.clear(webGL.COLOR_BUFFER_BIT);
    }

    return gl;
  }

  webGL.RenderingContext get gl => _gl;
}
