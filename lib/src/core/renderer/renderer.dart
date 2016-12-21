part of ose;

/// It works with your camera, scene and his objects to show them on screen.
class Renderer {
  /// Lifecycle controllers.
  final RendererLifecycleControllers lifecycleControllers;

  /// Renderer settings.
  final RendererSettings settings;

  /// Timer for delta time calculation.
  final utils.Timer timer;

  /// Managers take some work by themself, they know about [this._gl].
  RendererManagers _managers;

  /// Webgl renderer context.
  webGL.RenderingContext _gl;

  /// Canvas element to use.
  CanvasElement canvas;

  /// Current state of a renderer.
  RendererState _rendererState;

  /// Current delta time between two last frames.
  double _dt;

  Renderer({CanvasElement canvas, RendererSettings settings})
      : timer = new utils.Timer(),
        lifecycleControllers = new RendererLifecycleControllers(),
        settings = settings ?? new RendererSettings() {
    _init(canvas, this.settings);
  }

  /// Update viewport.
  void updateViewport(int width, int height) {
    if (camera != null) {
      camera.transform
        ..width = width
        ..height = height;
    }
    canvas.width = width;
    canvas.height = height;
    _gl.viewport(0, 0, width, height);
  }

  /// Register filters
  /// All filters must be registered by renderer to initialize it on startup.
  /// Please use that method before you set filters to objects.
  void registerFilters(List<Filter> filters) {
    if (_rendererState == RendererState.Started) {
      window.console.warn(
          'Please for best perfomance to register your filters before start invokes.');
    } else {
      _managers.filterManager.filters = filters;
    }
  }

  /// Start renderer.
  Future start() async {
    _rendererState = RendererState.StartRequested;

    // Auto-resize window.
    if (settings.fullscreen) {
      window.addEventListener('resize', _setFullscreen, false);
    }

    // Initialize timer.
    timer.init();

    // Initialize IO.
    _managers.ioManager.bind();

    await lifecycleControllers.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    _rendererState = RendererState.Started;

    // Filters must be initialized before render starts.
    _managers.filterManager.initFilters();

    window.animationFrame.then(_render);
  }

  /// Stop renderer.
  Future stop() async {
    _rendererState = RendererState.StopRequested;

    // Unbind auto-resize.
    if (settings.fullscreen) {
      window.removeEventListener('resize', _setFullscreen, false);
    }

    // Unbind IO.
    _managers.ioManager.unbind();

    await lifecycleControllers.onStopCtrl
      ..add(new StopEvent(this))
      ..done;

    _rendererState = RendererState.Stopped;
  }

  /// Initialize renderer.
  _init(CanvasElement canvas, RendererSettings settings) {
    _rendererState = RendererState.Stopped;
    _initCanvas(canvas ?? new CanvasElement(), settings);
    _initWebGL(this.canvas, settings);

    if (_gl != null) {
      _initManagers(_gl);
      if (settings.fullscreen) {
        _setFullscreen();
      } else {
        updateViewport(this.canvas.width, this.canvas.height);
      }
    }
  }

  /// Initialize renderer managers.
  void _initManagers(webGL.RenderingContext gl) {
    _managers = new RendererManagers(gl);
  }

  /// Initialize canvas.
  void _initCanvas(CanvasElement canvas, settings) {
    this.canvas = canvas;
    this.canvas.width = settings.width;
    this.canvas.height = settings.height;
  }

  /// Initialize webgl.
  void _initWebGL(CanvasElement canvas, RendererSettings settings) {
    _gl = _createRenderingContext(canvas, settings);

    // tbd @andytyurin emit error by using of event listener.
    if (_gl == null) throw 'WebGL is not supported';

    // Disable depth.
    _gl.disable(webGL.DEPTH_TEST);

    // Enable blending.
    if (settings.useTransparent) {
      _gl.enable(webGL.BLEND);
      _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
    }

    // Clear with color.
    if (settings.useClear) {
      _gl.clearColor(0.0, 0.0, 0.0, 1.0);
      _gl.clear(webGL.COLOR_BUFFER_BIT);
    }
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext(
      CanvasElement canvas, RendererSettings settings) {
    return canvas.getContext3d(
        alpha: settings.useTransparent,
        premultipliedAlpha: settings.useTransparent,
        antialias: settings.useAntialias,
        stencil: settings.useMask,
        preserveDrawingBuffer: settings.useClear);
  }

  /// Rendering cycle.
  /// In best perfomance will be invoked 60 times per second.
  Future _render(num msSinceRendererStart) async {
    if (_rendererState != RendererState.StopRequested) {
      window.animationFrame.then(_render);

      double fpsThresholdPerFrame = 1000 / settings.fpsThreshold;

      timer.checkpoint(msSinceRendererStart);

      // Skip frame if fps threshold has been reached.
      if (timer.accumulator >= fpsThresholdPerFrame) {
        timer.subtractAccumulator(fpsThresholdPerFrame);

        _dt = (timer.delta > fpsThresholdPerFrame)
            ? timer.delta
            : fpsThresholdPerFrame;

        // Pre-render scene.
        await lifecycleControllers.onRenderCtrl
          ..add(new RenderEvent(_managers.sceneManager.activeScene,
              _managers.cameraManager.activeCamera, this))
          ..done;

        /// Render scene.
        await _renderScene(scene, camera);

        // Post-render scene.
        await lifecycleControllers.onPostRenderCtrl
          ..add(new PostRenderEvent(scene, camera, this))
          ..done;
      }
    }
  }

  /// Render scene.
  Future _renderScene(Scene scene, Camera camera) async {
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
      _gl.clear(clearMask);
    }

    if (scene == null) {
      throw 'Scene is not defined.';
    }

    if (camera == null) {
      throw 'Camera is not defined.';
    }

    /// Update scene logic.
    scene.update(dt, _managers.cameraManager);

    for (SceneObject obj in scene.children) {
      /// Per object pre-render.
      await lifecycleControllers.onObjectRenderCtrl
        ..add(new ObjectRenderEvent(obj, scene, camera, this))
        ..done;

      /// Render object.
      _renderObject(obj, scene, camera);

      _managers.ioManager.update();

      /// Per object post-render.
      await lifecycleControllers.onObjectPostRenderCtrl
        ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
        ..done;
    }
  }

  /// Render particular object.
  void _renderObject(SceneObject sceneObject, Scene scene, Camera camera) {
    _updateObject(sceneObject);

    if (sceneObject is Shape) {
      sceneObject.rebuildColors();
    }

    sceneObject.transform.updateModelMatrix();
    camera.transform.updateProjectionMatrix();

    // if (sceneObject is Sprite) {
    //   Texture texture = sceneObject.texture;
    //
    //   if (texture.glTexture == null) {
    //     _prepareTexture(texture);
    //   }
    // }

    if ((sceneObject as dynamic).glVertices != null) {
      if (sceneObject is Shape) {
        _drawByFilter(_managers.filterManager.basicFilter, sceneObject);
      }

      sceneObject.filters.forEach((filter) {
        _drawByFilter(filter, sceneObject);
      });
    }
  }

  /// Draw object by using of particular filter.
  void _drawByFilter(Filter filter, SceneObject obj) {
    FilterManager fm = _managers.filterManager;

    fm.activeFilter = filter;

    if (fm.activeFilter != null) {
      fm.activeFilter.apply(_managers.filterManager, obj, scene, camera);
      _managers.filterManager.bindFilter();
      _gl.drawArrays(webGL.TRIANGLE_STRIP, 0,
          (obj as dynamic).glVertices.length ~/ 2);
    }
  }

  /// Update object logic.
  void _updateObject(SceneObject sceneObject) {
    _updateObjectActor(sceneObject);
    sceneObject.update(dt);
  }

  /// Update object actor.
  void _updateObjectActor(SceneObject sceneObject) {
    if (sceneObject.actor != null) {
      Actor actor = sceneObject.actor;
      if (actor is ControlActor) {
        actor.update(scene, sceneObject, _managers.ioManager);
      } else {
        actor.update(scene, sceneObject);
      }
    }
  }

  void _setFullscreen([_]) => updateViewport(window.innerWidth, window.innerHeight);

  // void _prepareTexture(Texture texture) {
  //   webGL.Texture glTexture = _gl.createTexture();
  //   texture.glTexture = glTexture;
  //   _gl.bindTexture(webGL.TEXTURE_2D, glTexture);
  //   _gl.pixelStorei(webGL.UNPACK_FLIP_Y_WEBGL, 1);
  //   _gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
  //       webGL.UNSIGNED_BYTE, texture.image);
  //   _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.LINEAR);
  //   _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.LINEAR);
  //   _gl.generateMipmap(webGL.TEXTURE_2D);
  //   _gl.bindTexture(webGL.TEXTURE_2D, null);
  // }
  //
  // _bindTexture(Texture texture) {
  //   _gl.activeTexture(webGL.TEXTURE0);
  //   _gl.bindTexture(webGL.TEXTURE_2D, texture.glTexture);
  // }

  Scene get scene => _managers.sceneManager.activeScene;

  void set scene(Scene scene) {
    _managers.sceneManager.activeScene = scene;
  }

  Camera get camera => _managers.cameraManager.activeCamera;

  void set camera(Camera camera) {
    _managers.cameraManager.activeCamera = camera;
  }

  RendererState get state => _rendererState;

  Stream<StartEvent> get onStart => lifecycleControllers.onStartCtrl.stream;

  Stream<StopEvent> get onStop => lifecycleControllers.onStopCtrl.stream;

  Stream<RenderEvent> get onRender => lifecycleControllers.onRenderCtrl.stream;

  Stream<PostRenderEvent> get onPostRender =>
      lifecycleControllers.onPostRenderCtrl.stream;

  Stream<ObjectRenderEvent> get onObjectRender =>
      lifecycleControllers.onObjectRenderCtrl.stream;

  Stream<ObjectPostRenderEvent> get onObjectPostRender =>
      lifecycleControllers.onObjectPostRenderCtrl.stream;

  double get dt => _dt;

  int get fps => 1000 ~/ dt;
}
