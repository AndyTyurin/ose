part of ose_webgl;

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
  WebGLRenderer({CanvasElement canvas, WebGLRendererSettings rendererSettings})
      : super(canvas: canvas, rendererSettings: rendererSettings) {
    _gl = this._initWebGL();
  }

  /// See [ose.Renderer.renderScene].
  @override
  Future renderScene(ose.Scene scene, ose.Camera camera) async {
    // Create clear mask.
    int clearMask = 0x00;

    // Mask to clear color buffer.
    if (settings.useClear) {
      clearMask |= webGL.COLOR_BUFFER_BIT;
    }

    // Mask to clear stencil buffer.
    if (settings.useMask) {
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
  void renderObject(
      ose.GameObject gameObject, ose.Scene scene, ose.Camera camera) {
    super.renderObject(gameObject, scene, camera);

    if (settings.useMask) {
      /// TODO: Check how could be use mask manager.
      /// this.maskManager(gameObject, maskObject, MaskManager.intersect);
      /// this.maskManager(gameObject, maskObject, MaskManager.subtract);
      /// this.maskManager.subtract(gameObject, maskObject);
      /// this.maskManager.intersect(gameObject, maskObject);
    }

    // Temporary render only shapes.
    if (gameObject is Shape) {
      gameObject.filter.apply(gameObject, scene, camera);
      _gl.drawArrays(
          webGL.TRIANGLE_STRIP, 0, gameObject.glVertices.length ~/ 2);
    }
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext() {
    return this.canvas.getContext3d(
        alpha: settings.useTransparent,
        premultipliedAlpha: settings.useTransparent,
        antialias: settings.useAntialias,
        stencil: settings.useMask,
        preserveDrawingBuffer: settings.useClear);
  }

  /// Initialize WebGL.
  webGL.RenderingContext _initWebGL() {
    webGL.RenderingContext gl = this._createRenderingContext();

    _preserveRenderingContextToGlobals(gl);

    if (gl == null) throw 'WebGL is not supported';

    // Disable depth.
    gl.disable(webGL.DEPTH_TEST);

    // Enable stencil buffer usage.
    if (settings.useMask) {
      gl.enable(webGL.STENCIL_TEST);
    }

    // Enable blending.
    if (settings.useTransparent) {
      gl.enable(webGL.BLEND);
      gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
    }

    // Clear with color.
    if (settings.useClear) {
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      gl.clear(webGL.COLOR_BUFFER_BIT);
    }

    return gl;
  }

  updateViewport() {
    camera.transform
      ..width = canvas.width
      ..height = canvas.height;
    gl.viewport(0, 0, canvas.width, canvas.height);
  }

  /// Keep rendering context link inside common classes.
  void _preserveRenderingContextToGlobals(webGL.RenderingContext gl) {
    Attribute.gl = gl;
    ShaderProgramManager.gl = gl;
    ShaderProgram.gl = gl;
    Shader.gl = gl;
  }

  webGL.RenderingContext get gl => _gl;
}
