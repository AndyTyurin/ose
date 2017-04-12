part of ose;

/// Renderer is engine core, responds for components synchronization and showing
/// objects on a screen.
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

  /// Used to draw graphics.
  RendererDrawer _drawer;

  /// Current delta time between two last frames.
  double _dt;

  /// Pass the [canvas] if you would like to use already defined or
  /// skip to generate a new one.
  /// Additional settings can be specified in [settings] argument.
  Renderer({CanvasElement canvas, RendererSettings settings})
      : timer = new utils.Timer(),
        lifecycleControllers = new RendererLifecycleControllers(),
        settings = settings ?? new RendererSettings() {
    _init(canvas, this.settings);
  }

  /// Update webgl viewport, canvas size and camera transformation matrix.
  /// Useful when you manually control canvas size and want to change it with
  /// graphics on it.
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

  /// Start renderer.
  Future start() async {
    _rendererState = RendererState.StartRequested;

    // If [settings.fullscreen] is [true], automatically set full screen
    // on resize.
    if (settings.fullscreen) {
      _setFullscreen();
      window.addEventListener('resize', _setFullscreen, false);
    } else {
      // Set viewport by canvas size.
      updateViewport(canvas.width, canvas.height);
    }

    // Set initial checkpoint for timer.
    timer.init();

    // Set up IO devices to control actors.
    // tbd @andytyurin which to use can be specified in settings.
    _managers.ioManager.bind();

    // There can be initialized something before rendering starts.
    // For example to load critical resources or make some preparations before,
    // also it could be easily hooked if needed.
    await lifecycleControllers.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    _rendererState = RendererState.Started;

    // Start animation frame in rendering closure.
    window.animationFrame.then(_render);
  }

  /// Request renderer to stop.
  /// It will be stopped on next cycle of rendering.
  void stop() {
    _rendererState = RendererState.StopRequested;

    // Unbind auto-resize if settings switched on.
    if (settings.fullscreen) {
      window.removeEventListener('resize', _setFullscreen, false);
    }

    // Unbind IO devices.
    _managers.ioManager.unbind();

    _rendererState = RendererState.Stopped;
  }

  /// Register shader program.
  /// [name] is unique shader program's id.
  /// [vSource] and [fSource] are vertex and fragment shaders' sources.
  /// To use common header definitions for your sources, set
  /// [useCommonDefinitions] to [true].
  bool registerShaderProgram(String name, String vSource, String fSource,
      {bool useCommonDefinitions}) {
    return _managers.shaderProgramManager.register(name, vSource, fSource,
        useCommonDefinitions: useCommonDefinitions);
  }

  /// Initialize renderer.
  _init(CanvasElement canvas, RendererSettings settings) {
    _rendererState = RendererState.Stopped;

    // Create and setup passed canvas or initialize a new one.
    _initCanvas(canvas ?? new CanvasElement(), settings);

    // Initialize webgl.
    _initWebGL(this.canvas, settings);

    if (_gl != null) {
      // Initialize composed managers. There are responds to simplify logic
      // of renderer by handling specific tasks of it.
      _initManagers(_gl);
      _drawer = new RendererDrawer(
          _gl, _managers.shaderProgramManager, settings.shaderVariables);
    }
  }

  /// Initialize renderer managers.
  /// There are resolve different tasks to make renderer's logic easier.
  void _initManagers(webGL.RenderingContext gl) {
    _managers = new RendererManagers(gl, onTextureRegister: _onTextureRegister);
  }

  /// Initialize canvas element.
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

    // Use depth buffer.
    if (settings.useDepth) {
      _gl.enable(webGL.DEPTH_TEST);
    } else {
      _gl.disable(webGL.DEPTH_TEST);
    }

    // Enable blending.
    _gl.enable(webGL.BLEND);
    _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);

    // Clear with color.
    if (settings.useClear) {
      _gl.clearColor(0.0, 0.0, 0.0, 1.0);
      _gl.clear(webGL.COLOR_BUFFER_BIT);
    }
  }

  /// Prepare texture.
  /// tbd @andytyurin better to define inside [TextureManager]?
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
  /// Limited by fps threshold and 60 fps as max border.
  Future _render(num msSinceRendererStart) async {
    if (_rendererState != RendererState.StopRequested) {
      // Ask to render again after current rendering iteration.
      window.animationFrame.then(_render);

      // Frame threshold in ms.
      double frameThresholdMs = 1000 / settings.fpsThreshold;

      // Measure delta by calculating difference of last checkpoint.
      // Also accumulates time that will be compared with threshold limit.
      timer.checkpoint(msSinceRendererStart);

      // Skip frame if threshold reached.
      if (timer.accumulator >= frameThresholdMs) {
        // Subtract accumulator by threshold limit.
        timer.subtractAccumulator(frameThresholdMs);

        // Calculate delta time in ms.
        // It could be used by objects for smooth rendering on movement.
        _dt = (timer.delta > frameThresholdMs) ? timer.delta : frameThresholdMs;

        // Fire [RenderEvent].
        // By using of event handler you can update your logic.
        await lifecycleControllers.onRenderCtrl
          ..add(new RenderEvent(_managers.sceneManager.activeScene,
              _managers.cameraManager.activeCamera, this))
          ..done;

        /// Render scene.
        await _renderScene(scene, camera);

        // Post rendering step.
        await lifecycleControllers.onPostRenderCtrl
          ..add(new PostRenderEvent(scene, camera, this))
          ..done;
      }
    } else {
      // Push about stopping.
      lifecycleControllers.onStopCtrl
        ..add(new StopEvent(this))
        ..done;
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

    if (settings.useDepth) {
      clearMask |= webGL.DEPTH_BUFFER_BIT;
    }

    // Clear buffers by defined mask.
    if (clearMask > 0x00) {
      _gl.clear(clearMask);
    }
  }

  /// Render active scene.
  Future _renderScene(Scene scene, Camera camera) async {
    if (scene == null) {
      window.console.error('Scene is not defined, rendering aborted');
      stop();
    }

    if (camera == null) {
      window.console.error('Camera is not defined, rendering aborted');
      stop();
    }

    // Clear buffers before drawing.
    _clear();

    // Update scene logic.
    scene.update(dt, _managers.cameraManager);

    // Update lightning.
    // Light can be complicated, prefer to calculate some logic on cpu part.
    _updateLights(scene.lights);

    // Update camera's projection & view matrices.
    camera.transform.updateProjectionMatrix();
    camera.transform.updateViewMatrix();

    // Delegate drawing to drawer.
    await _drawer.draw(scene.children, _onObjectRender, _onObjectPostRender);

    // Update IO devices.
    _managers.ioManager.update();
  }

  /// Object render callback is invoked by [RendererDrawer].
  /// The method will be invoked before drawing, so specific logic can be
  /// defined on listener along with object's updating declared here.
  /// It will update object's actor if it present, object itself and model
  /// matrix calculations.
  Future _onObjectRender(SceneObject obj) async {
    // Fire object render event.
    // Event handler can be defined to handle each object.
    await lifecycleControllers.onObjectRenderCtrl
      ..add(new ObjectRenderEvent(obj, _managers.sceneManager.boundScene,
          _managers.cameraManager.activeCamera, this))
      ..done;

    // Update object's logic.
    obj.update(dt);
  }

  /// Object post render callback is invoked by [RendererDrawer].
  Future _onObjectPostRender(SceneObject obj) async {
    // Fire post render event.
    // Event handler can be defined to handle each object after rendering.
    await lifecycleControllers.onObjectPostRenderCtrl
      ..add(new ObjectPostRenderEvent(obj, _managers.sceneManager.boundScene,
          _managers.cameraManager.activeCamera, this))
      ..done;
  }

  // void _drawShape(Shape shape) {
  //   shape.rebuildColors();
  //   _drawByFilter(_managers.filterManager.basicFilter, shape);
  // }

  // void _drawSprite(Sprite sprite) {
  //   _managers.textureManager.bindTexture(sprite.texture, TextureType.Color);
  //   if (sprite.normalMap != null) {
  //     _managers.textureManager
  //         .bindTexture(sprite.normalMap, TextureType.Normal);
  //   }
  //   _drawByFilter(_managers.filterManager.spriteFilter, sprite);
  //   // _drawByLightning(sprite, scene.lights);
  //   _managers.textureManager.unbindTexture(TextureType.Color);
  //   _managers.textureManager.unbindTexture(TextureType.Normal);
  // }

  // void _drawSingle(SceneObject sceneObject) {
  //   _updateObject(sceneObject);
  //   sceneObject.transform.updateModelMatrix();
  //   if (sceneObject is Sprite) {
  //     _drawSprite(sceneObject);
  //   } else if (sceneObject is Shape) {
  //     _drawShape(sceneObject);
  //   }
  //
  //   _applyFilters(sceneObject);
  // }

  // void _applyFilters(SceneObject sceneObject) {
  //   sceneObject.filters.forEach((filter) {
  //     _drawByFilter(filter, sceneObject);
  //   });
  // }

  void _updateLights(Iterable<Light> lights) {
    lights.forEach(_updateLight);
  }

  void _updateLight(Light light) {
    light.update(dt);
  }

  // void _drawGroup(SceneObjectGroup group) {
  //   group.transform.updateModelMatrix();
  //   group.children.forEach((sceneObject) {
  //     _drawSingle(sceneObject);
  //   });
  // }

  /// Draw object by using of particular filter.
  /// Be careful, objects should have [glVertices].
  // void _drawByFilter(Filter filter, SceneObject obj) {
  //   FilterManager fm = _managers.filterManager;
  //
  //   fm.activeFilter = filter;
  //   if (fm.activeFilter != null) {
  //     fm.activeFilter.apply(_managers.filterManager, obj, scene, camera);
  //     _managers.filterManager.bindFilter();
  //     _gl.drawArrays(
  //         webGL.TRIANGLE_STRIP, 0, (obj as dynamic).glVertices.length ~/ 2);
  //   }
  // }

  // void _drawByLightning(Sprite obj, Iterable<Light> lights) {
  //   SpriteFilter activeFilter = _managers.filterManager.activeFilter;
  //   _gl.blendFunc(webGL.SRC_ALPHA, webGL.DST_ALPHA);
  //   lights.forEach((light) {
  //     activeFilter.setActiveLight(light);
  //     _drawByFilter(activeFilter, obj);
  //   });
  //   _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
  // }

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
