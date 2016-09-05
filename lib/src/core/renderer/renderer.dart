part of ose;

class Renderer {
  static webGL.RenderingContext gl;

  final RendererLifecycleControllers _lifecycleControllers;

  final RendererSettings _rendererSettings;

  final utils.Timer _timer;

  CanvasElement canvas;

  Camera camera;

  Scene scene;

  RendererState _rendererState;

  Renderer({CanvasElement canvas, RendererSettings rendererSettings})
      : _timer = new utils.Timer(),
        _lifecycleControllers = new RendererLifecycleControllers(),
        _rendererSettings = rendererSettings {
    this.canvas = canvas ?? new CanvasElement();
    gl = this._initWebGL(this.canvas);
    _rendererState = RendererState.Stopped;
    setCanvasDimensions(_rendererSettings.width, _rendererSettings.height,
        _rendererSettings.pixelRatio);
  }

  Future start() async {
    _rendererState = RendererState.StartRequested;

    // Initialize timer.
    _timer.init();

    await _lifecycleControllers.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    _rendererState = RendererState.Started;

    window.animationFrame.then(render);
  }

  Future stop() async {
    _rendererState = RendererState.StopRequested;

    await _lifecycleControllers.onStopCtrl
      ..add(new StopEvent(this))
      ..done;

    _rendererState = RendererState.Stopped;
  }

  Future render(num dt) async {
    if (_rendererState != RendererState.StopRequested) {
      window.animationFrame.then(render);

      _timer.checkpoint(dt);

      // Skip frame if fps threshold was reached.
      if (_timer.accumulator >= (1 / _rendererSettings.fpsThreshold)) {
        _timer.subtractAccumulator(_rendererSettings.fpsThreshold);
        return;
      }

      // Pre-render scene.
      await _lifecycleControllers.onRenderCtrl
        ..add(new RenderEvent(scene, camera, this))
        ..done;

      /// Render scene.
      await renderScene(scene, camera);

      // Post-render scene.
      await _lifecycleControllers.onPostRenderCtrl
        ..add(new PostRenderEvent(scene, camera, this))
        ..done;
    }
  }

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

    if (scene == null) {
      throw 'Scene is not defined.';
    }

    if (camera == null) {
      throw 'Camera is not defined.';
    }

    for (GameObject obj in scene.children) {
      if (_isObjectRenderable(obj)) {
        /// Per object pre-render.
        await _lifecycleControllers.onObjectRenderCtrl
          ..add(new ObjectRenderEvent(obj, scene, camera, this))
          ..done;

        /// Render object.
        renderObject(obj, scene, camera);

        /// Per object post-render.
        await _lifecycleControllers.onObjectPostRenderCtrl
          ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
          ..done;
      }
    }
  }

  void renderObject(
      SceneObject sceneObject, Scene scene, Camera camera) {
    if (sceneObject is Shape) {
      sceneObject.rebuildColors();
    }

    sceneObject.transform.updateModelMatrix();
    camera.transform.updateProjectionMatrix();

    if (settings.useMask) {
      /// TODO: Check how could be use mask manager.
      /// this.maskManager(gameObject, maskObject, MaskManager.intersect);
      /// this.maskManager(gameObject, maskObject, MaskManager.subtract);
      /// this.maskManager.subtract(gameObject, maskObject);
      /// this.maskManager.intersect(gameObject, maskObject);
    }

    // Temporary render only shapes.
    if (sceneObject is Shape) {
      sceneObject.filter.apply(sceneObject, scene, camera);
      gl.drawArrays(webGL.TRIANGLE_STRIP, 0, sceneObject.glVertices.length ~/ 2);
    }
  }

  /// Set canvas width & height.
  setCanvasDimensions(int width, int height, [int pixelRatio = 1]) {
    canvas.width ??= (width * pixelRatio);
    canvas.height ??= (height * pixelRatio);
  }

  /// Check is object renderable.
  bool _isObjectRenderable(SceneObject sceneObject) {
    return true;
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext(CanvasElement canvas) {
    return canvas.getContext3d(
        alpha: settings.useTransparent,
        premultipliedAlpha: settings.useTransparent,
        antialias: settings.useAntialias,
        stencil: settings.useMask,
        preserveDrawingBuffer: settings.useClear);
  }

  /// Initialize WebGL.
  webGL.RenderingContext _initWebGL(CanvasElement canvas) {
    webGL.RenderingContext gl = _createRenderingContext(canvas);

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

  RendererSettings get settings => _rendererSettings;

  RendererState get state => _rendererState;

  Stream<StartEvent> get onStart => _lifecycleControllers.onStartCtrl.stream;

  Stream<StopEvent> get onStop => _lifecycleControllers.onStopCtrl.stream;

  Stream<RenderEvent> get onRender => _lifecycleControllers.onRenderCtrl.stream;

  Stream<PostRenderEvent> get onPostRender =>
      _lifecycleControllers.onPostRenderCtrl.stream;

  Stream<ObjectRenderEvent> get onObjectRender =>
      _lifecycleControllers.onObjectRenderCtrl.stream;

  Stream<ObjectPostRenderEvent> get onObjectPostRender =>
      _lifecycleControllers.onObjectPostRenderCtrl.stream;

  num get dt => _timer.delta;

  num get fps => 1000 ~/ dt;
}
