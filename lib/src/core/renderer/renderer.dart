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
    _managers = new RendererManagers(gl,
        onFilterRegister: _onFilterRegister,
        onTextureRegister: _onTextureRegister);
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
    _gl.enable(webGL.BLEND);
    _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);

    // Clear with color.
    if (settings.useClear) {
      _gl.clearColor(0.0, 0.0, 0.0, 1.0);
      _gl.clear(webGL.COLOR_BUFFER_BIT);
    }
  }

  /// Prepare filter.
  void _onFilterRegister(FilterRegisterEvent e) {
    _managers.filterManager.prepareFilter(e.filter);
  }

  /// Prepare texture.
  void _onTextureRegister(TextureRegisterEvent e) {
    _managers.textureManager.prepareTexture(e.texture);
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext(
      CanvasElement canvas, RendererSettings settings) {
    return canvas.getContext3d(
        alpha: settings.useAlpha,
        premultipliedAlpha: settings.useAlpha,
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

        // Pre rendering step.
        await lifecycleControllers.onRenderCtrl
          ..add(new RenderEvent(_managers.sceneManager.activeScene,
              _managers.cameraManager.activeCamera, this))
          ..done;

        // Clear buffers before usage.
        _clear();

        /// Render scene.
        await _renderScene(scene, camera);

        // Post rendering step.
        await lifecycleControllers.onPostRenderCtrl
          ..add(new PostRenderEvent(scene, camera, this))
          ..done;
      }
    }
  }

  /// Clear buffers.
  /// Mostly used before rendering of new frame
  void _clear() {
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
  }

  /// Render scene.
  Future _renderScene(Scene scene, Camera camera) async {
    if (scene == null) {
      throw 'Scene is not defined.';
    }

    if (camera == null) {
      throw 'Camera is not defined.';
    }

    // Update scene logic.
    scene.update(dt, _managers.cameraManager);

    // Update lightning.
    _updateLights(scene.lights);

    // Update camera
    camera.transform.updateProjectionMatrix();
    camera.transform.updateViewMatrix();

    // Traverse by objects.
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
    if (sceneObject is SceneObjectGroup) {
      _drawGroup(sceneObject);
    } else {
      _drawObject(sceneObject);
    }
  }

  void _drawShape(Shape shape) {
    shape.rebuildColors();
    _drawByFilter(_managers.filterManager.basicFilter, shape);
  }

  void _drawSprite(Sprite sprite) {
    _managers.textureManager.bindTexture(sprite.texture, TextureType.Color);
    if (sprite.normalMap != null) {
      _managers.textureManager
          .bindTexture(sprite.normalMap, TextureType.Normal);
    }
    _drawByFilter(_managers.filterManager.spriteFilter, sprite);
    // _drawByLightning(sprite, scene.lights);
    _managers.textureManager.unbindTexture(TextureType.Color);
    _managers.textureManager.unbindTexture(TextureType.Normal);
  }

  void _drawObject(SceneObject sceneObject) {
    _updateObject(sceneObject);
    sceneObject.transform.updateModelMatrix();
    if (sceneObject is Sprite) {
      _drawSprite(sceneObject);
    } else if (sceneObject is Shape) {
      _drawShape(sceneObject);
    }

    _applyFilters(sceneObject);
  }

  void _applyFilters(SceneObject sceneObject) {
    sceneObject.filters.forEach((filter) {
      _drawByFilter(filter, sceneObject);
    });
  }

  void _updateLights(Iterable<Light> lights) {
    lights.forEach(_updateLight);
  }

  void _updateLight(Light light) {
    light.update(dt);
  }

  void _drawGroup(SceneObjectGroup group) {
    group.transform.updateModelMatrix();
    group.children.forEach((sceneObject) {
      _drawObject(sceneObject);
    });
  }

  /// Draw object by using of particular filter.
  /// Be careful, objects should have [glVertices].
  void _drawByFilter(Filter filter, SceneObject obj) {
    FilterManager fm = _managers.filterManager;

    fm.activeFilter = filter;
    if (fm.activeFilter != null) {
      fm.activeFilter.apply(_managers.filterManager, obj, scene, camera);
      _managers.filterManager.bindFilter();
      _gl.drawArrays(
          webGL.TRIANGLE_STRIP, 0, (obj as dynamic).glVertices.length ~/ 2);
    }
  }

  // void _drawByLightning(Sprite obj, Iterable<Light> lights) {
  //   SpriteFilter activeFilter = _managers.filterManager.activeFilter;
  //   _gl.blendFunc(webGL.SRC_ALPHA, webGL.DST_ALPHA);
  //   lights.forEach((light) {
  //     activeFilter.setActiveLight(light);
  //     _drawByFilter(activeFilter, obj);
  //   });
  //   _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
  // }

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

  void _setFullscreen([_]) =>
      updateViewport(window.innerWidth, window.innerHeight);

  Scene get scene => _managers.sceneManager.activeScene;

  void set scene(Scene scene) {
    _managers.sceneManager.activeScene = scene;
  }

  Camera get camera => _managers.cameraManager.activeCamera;

  void set camera(Camera camera) {
    _managers.cameraManager.activeCamera = camera;
  }

  AssetManager get assetManager => _managers.assetManager;

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
