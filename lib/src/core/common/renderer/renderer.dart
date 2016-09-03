part of ose;

// TODO: Try to use delta time derived from animation rendering loop.
// TODO: Setup stencil manager.

/// Renderer.
/// Has common rendering features, such as pre-post-rendering events,
/// rendering loop, fps thresholding etc.
/// As renderer is directly dependent on camera and scene, there are keeped
/// inside and accessible outside, to control & cache scenes and cameras.
///
/// Renderer is abstract class, overrided by specific [WebGLRenderer]
/// or [CanvasRenderer].
abstract class Renderer {
  final RendererLifecycleControllers _lifecycleControllers;

  final RendererSettings _rendererSettings;

  /// Timer.
  /// Set checkpoints while rendering to calculate delta time between frames.
  /// Can be used to retrieve the delta time between two last frames.
  final utils.Timer _timer;

  /// View canvas element.
  CanvasElement _canvas;

  Camera camera;

  Scene scene;

  RendererState _rendererState;

  /// Create renderer.
  /// [canvas] - link to specific [CanvasElement].
  Renderer({CanvasElement canvas, RendererSettings rendererSettings})
      : _timer = new utils.Timer(),
        _lifecycleControllers = new RendererLifecycleControllers(),
        _rendererSettings = rendererSettings {
    _canvas = canvas ?? new CanvasElement();
    _rendererState = RendererState.Stopped;
    setCanvasDimensions(_rendererSettings.width, _rendererSettings.height,
        _rendererSettings.pixelRatio);
  }

  /// Start rendering.
  @mustCallSuper
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

  /// Request stop rendering.
  @mustCallSuper
  Future stop() async {
    _rendererState = RendererState.StopRequested;

    await _lifecycleControllers.onStopCtrl
      ..add(new StopEvent(this))
      ..done;

    _rendererState = RendererState.Stopped;
  }

  /// Render loop.
  @protected
  @mustCallSuper
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

  /// Render scene.
  @protected
  @mustCallSuper
  Future renderScene(Scene scene, Camera camera) async {
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

  /// Render object.
  /// Note: Must be overrided by specific renderer.
  @protected
  void renderObject(GameObject gameObject, Scene scene, Camera camera) {
    if (gameObject is Shape) {
      gameObject.rebuildColors();
    }
    gameObject.transform.updateModelMatrix();
    camera.transform.updateProjectionMatrix();
  }

  /// Set canvas width & height.
  setCanvasDimensions(int width, int height, [int pixelRatio = 1]) {
    _canvas.width ??= (width * pixelRatio);
    _canvas.height ??= (height * pixelRatio);
  }

  /// Check is object renderable.
  bool _isObjectRenderable(GameObject gameObject) {
    return true;
  }

  CanvasElement get canvas => _canvas;

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
