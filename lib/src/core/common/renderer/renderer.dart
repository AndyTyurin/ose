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
  /// View canvas element.
  CanvasElement _canvas;

  /// Manage scenes.
  /// [SceneManager] could be extended by user, if it needed to implement his
  /// own stuff, for example to add additional cache mechanisms or make
  /// some prepations before set a scene to be an active.
  /// Your own scene manager could be set in parameters of the renderer.
  SceneManager _sceneManager;

  /// Manage cameras.
  /// [CameraManager] could be extended by user, if it needed to implement his
  /// own stuff, for example to add additonal cache mehanisms or make
  /// some preparations before set a camera to be an active.
  /// Your own camera manager could be set in parameters of the renderer.
  CameraManager _cameraManager;

  /// Timer.
  /// Set checkpoints while rendering to calculate delta time between frames.
  /// Can be used to retrieve the delta time between two last frames.
  utils.Timer _timer;

  /// Is render stop requested.
  /// Stop renderer ASAP.
  bool _isRenderStopRequested;

  /// Is renderer to use transparent canvas or not.
  bool _useTransparent;

  /// Is renderer should to resize canvas on dimension change.
  bool _useAutoResize;

  /// Use masking (use mask manager).
  bool _useMask;

  /// Use clear color buffer on next frame.
  bool _useClear;

  /// Use anti-alias.
  bool _useAntialias;

  /// Background clear color.
  bool _clearColor;

  /// FPS top-level threshold.
  num _fpsThreshold;

  /// On start stream.
  /// Will be triggered on start rendering.
  /// Listen stream to fetch [StartEvent].
  Stream<StartEvent> _onStart;

  /// On stop stream.
  /// Will be triggered on stop rendering.
  /// Listen stream to fetch [StopEvent].
  Stream<StopEvent> _onStop;

  /// On render stream.
  /// Will be triggered at the start of a frame rendering.
  /// Listen stream to fetch [RenderEvent].
  Stream<RenderEvent> _onRender;

  /// On post render stream.
  /// Will be triggered at the end of a frame rendering.
  /// Listen stream to fetch [PostRenderEvent].
  Stream<PostRenderEvent> _onPostRender;

  /// On object render stream.
  /// Will be triggered before object rendering.
  /// Listen stream to fetch [ObjectRender].
  Stream<ObjectRenderEvent> _onObjectRender;

  /// On object post render stream.
  /// Will be triggered after object rendering.
  /// Listen stream to fetch [ObjectPostRenderEvent].
  Stream<ObjectPostRenderEvent> _onObjectPostRender;

  /// Stream controller for [_onStart] stream.
  @protected
  final StreamController<StartEvent> onStartCtrl;

  /// Stream controller for [_onStop] stream.
  @protected
  final StreamController<StopEvent> onStopCtrl;

  /// Stream controller for [_onRender] stream.
  @protected
  final StreamController<RenderEvent> onRenderCtrl;

  /// Stream controller for [_onPostRender] stream.
  @protected
  final StreamController<PostRenderEvent> onPostRenderCtrl;

  /// Stream controller for [_onObjectRender] stream.
  @protected
  final StreamController<ObjectRenderEvent> onObjectRenderCtrl;

  /// Stream controller for [_onObjectPostRender] stream.
  @protected
  final StreamController<ObjectPostRenderEvent> onObjectPostRenderCtrl;

  /// Create renderer.
  /// [canvas] - link to specific [CanvasElement].
  /// [width] - canvas width.
  /// [height] - canvas height.
  /// [pixelRatio] - 2x for retina, 1x for custom screen.
  /// [fps] - fps threshold. Min is 1, max is 60.
  /// [autoResize] - resize canvas on screen dimension change.
  /// [transparent] - is canvas transparent or not.
  /// [mask] - if true, gives opportunity to work with mask manager.
  /// [color] - fill background with color, only if [clear] is [true].
  /// [clear] - clear color buffer on next frame.
  /// [antialias] - use antialias.
  Renderer(
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
      : this._timer = new utils.Timer(),
        this.onStartCtrl = new StreamController<StartEvent>(),
        this.onStopCtrl = new StreamController<StopEvent>(),
        this.onRenderCtrl = new StreamController<RenderEvent>(),
        this.onPostRenderCtrl = new StreamController<PostRenderEvent>(),
        this.onObjectRenderCtrl = new StreamController<ObjectRenderEvent>(),
        this.onObjectPostRenderCtrl =
            new StreamController<ObjectPostRenderEvent>(),
        this._sceneManager = new SceneManager(),
        this._cameraManager = new CameraManager(),
        this._useTransparent = transparent,
        this._useAutoResize = autoResize,
        this._useMask = mask,
        this._clearColor = color,
        this._useClear = clear,
        this._useAntialias = antialias {
    this._onStart = this.onStartCtrl.stream;
    this._onStop = this.onStopCtrl.stream;
    this._onRender = this.onRenderCtrl.stream;
    this._onPostRender = this.onPostRenderCtrl.stream;
    this._onObjectRender = this.onObjectRenderCtrl.stream;
    this._onObjectPostRender = this.onObjectPostRenderCtrl.stream;
    this._fpsThreshold = math.max(1, math.min(60, fps));
    this._canvas = canvas ?? new CanvasElement();
    this.setCanvasDimensions(
        width ?? this._canvas.width, height ?? this._canvas.height, pixelRatio);
  }

  /// Start rendering.
  @mustCallSuper
  Future start() async {
    // Initialize timer.
    _timer.checkpoint();
    _timer.flush();

    await this.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    window.animationFrame.then(this.render);
  }

  /// Request stop rendering.
  @mustCallSuper
  Future stop() async {
    this._isRenderStopRequested = true;

    await this.onStopCtrl
      ..add(new StopEvent(this))
      ..done;
  }

  /// Render loop.
  @protected
  @mustCallSuper
  Future render(num dt) async {
    if (!this._isRenderStopRequested) {
      window.animationFrame.then(this.render);

      this._timer.checkpoint();

      // Skip frame if fps threshold was reached.
      if (this._timer.accumulator >= this._fpsThreshold) {
        this._timer.subtract(this._fpsThreshold);
        return null;
      }

      // Grab active scene & camera from managers.
      Scene scene = this._sceneManager.active;
      Camera camera = this._cameraManager.active;

      // Pre-render scene.
      await this.onRenderCtrl
        ..add(new RenderEvent(scene, camera, this))
        ..done;

      /// Render scene.
      await this.renderScene(scene, camera);

      // Post-render scene.
      await this.onPostRenderCtrl
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
      if (this._isObjectRenderable(obj)) {
        /// Per object pre-render.
        await this.onObjectRenderCtrl
          ..add(new ObjectRenderEvent(obj, scene, camera, this))
          ..done;

        /// Render object.
        this.renderObject(obj, scene, camera);

        /// Per object post-render.
        await this.onObjectPostRenderCtrl
          ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
          ..done;
      }
    }
  }

  /// Render object.
  /// Note: Must be overrided by specific renderer.
  @protected
  Future renderObject(GameObject gameObject, Scene scene, Camera camera);

  /// Set canvas width & height.
  setCanvasDimensions(int width, int height, [int pixelRatio = 1]) {
    this._canvas.width ??= (width * pixelRatio);
    this._canvas.height ??= (height * pixelRatio);
  }

  /// Check is object renderable.
  bool _isObjectRenderable(GameObject gameObject) {
    return gameObject.isRenderable;
  }

  CanvasElement get canvas => this._canvas;

  SceneManager get sceneManager => this._sceneManager;

  CameraManager get cameraManager => this._cameraManager;

  bool get isRenderStopRequested => this._isRenderStopRequested;

  bool get useTransparent => this._useTransparent;

  bool get useAutoResize => this._useAutoResize;

  bool get useMask => this._useMask;

  bool get useClear => this._useClear;

  bool get useAntialias => this._useAntialias;

  bool get clearColor => this._clearColor;

  Stream<StartEvent> get onStart => this._onStart;

  Stream<StopEvent> get onStop => this._onStop;

  Stream<RenderEvent> get onRender => this._onRender;

  Stream<PostRenderEvent> get onPostRender => this._onPostRender;

  Stream<ObjectRenderEvent> get onObjectRender => this._onObjectRender;

  Stream<ObjectPostRenderEvent> get onObjectPostRender =>
      this._onObjectPostRender;

  num get dt => this._timer.delta;

  num get fps => 1 / this.dt;
}

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
  /// [GameObject] in use.
  GameObject gameObject;

  ObjectRenderEvent(
      this.gameObject, Scene scene, Camera camera, Renderer renderer)
      : super(scene, camera, renderer);
}

/// Object post render event.
/// Note: see [onPostRenderEvent] method.
class ObjectPostRenderEvent extends ObjectRenderEvent {
  ObjectPostRenderEvent(
      GameObject gameObject, Scene scene, Camera camera, Renderer renderer)
      : super(gameObject, scene, camera, renderer);
}
