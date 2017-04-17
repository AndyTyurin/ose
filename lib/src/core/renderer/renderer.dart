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

    // Register common shader programs.
    _registerCommonShaderPrograms();

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

  /// Register a new shader program.
  /// New shader program will be created and registered by using of unique key
  /// [name] and shader sources:
  /// - vertex source [vSource];
  /// - fragment source [fSource].
  /// Each program should have defined [attributes] and [uniforms] to pass
  /// data from cpu to gpu. Some of them already defined if [useCommonDefinitions] is set to [true].
  bool registerShaderProgram(String name, String vSource, String fSource,
      {Map<String, Attribute> attributes,
      Map<String, Uniform> uniforms,
      bool useCommonDefinitions}) {
    return _managers.shaderProgramManager.register(name, vSource, fSource,
        attributes: attributes,
        uniforms: uniforms,
        useCommonDefinitions: useCommonDefinitions);
  }

  /// Update attributes' values for bound shader program.
  /// [values] is map with attributes' names and appropriate values.
  void updateAttributes(Map<String, dynamic> values) {
    _managers.shaderProgramManager.updateAttributes(values);
  }

  /// Update uniforms' values for bound shader program.
  /// [values] is map with uniforms' names and appropriate values.
  void updateUniforms(Map<String, dynamic> values) {
    _managers.shaderProgramManager.updateUniforms(values);
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
      _drawer = new RendererDrawer(_gl, _managers.shaderProgramManager);
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

  /// Register common shader programs (sprite, shape).
  void _registerCommonShaderPrograms() {
    // Register shape's shader program.
    registerShaderProgram(Shape.shaderProgramName,
        Shape.getVertexShaderSource(), Shape.getFragmentShaderSource(),
        attributes: <String, Attribute>{'a_color': new Attribute.FloatArray4()},
        useCommonDefinitions: true);
    // Register sprite's shader program.
    registerShaderProgram(
        Sprite.shaderProgramName,
        Sprite.getVertexShaderSource(settings.maxLights),
        Sprite.getFragmentShaderSource(settings.maxLights),
        attributes: <String, Attribute>{
          'a_texCoord': new Attribute.FloatArray2()
        },
        uniforms: <String, Uniform>{
          'u_colorMap': new Uniform.Int1(0),
          'u_normalMap': new Uniform.Int1(1),
          'u_ambientLightColor': new Uniform.Float4(),
          'u_lightDirection': new Uniform.FloatArray2(),
          'u_lightPosition': new Uniform.FloatArray2(),
          'u_lightColor': new Uniform.FloatArray4(),
          'u_lightFalloff': new Uniform.FloatArray3(),
          'u_lightType': new Uniform.IntArray1(),
          'u_useNormalMap': new Uniform.Bool1(false)
        },
        useCommonDefinitions: true);
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
          ..add(new RenderEvent(scene, camera, this))
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

    // Update lightning.
    // Light can be complicated, prefer to calculate some logic on cpu part.
    _updateLights(scene.lights);

    // Update camera's logic
    _managers.cameraManager.update(dt);

    // Update scene, nested children and actors through the scene manager.
    _managers.sceneManager.update(dt, _managers.ioManager.inputControllers);

    // Delegate drawing of scene's children to drawer.
    await _drawer.draw(scene.children, _onObjectDraw, _onObjectPostDraw);

    // Update IO devices.
    _managers.ioManager.update();
  }

  /// Object render callback is invoked by [RendererDrawer].
  ///
  /// The method will be invoked before drawing, so specific logic can be
  /// defined on listener along with object's updating declared here.
  ///
  /// If the passed [obj] is one of the commons, such as [Shape] or [Sprite],
  /// appropriate attributes and uniforms will be automatically updated here.
  ///
  /// By using of [onObjectRender] stream, you can easilly add specific logic
  /// to deal with your own attributes and uniforms.
  Future _onObjectDraw(SceneObject obj) async {
    // Update common attributes & uniforms specified for all kinds of objects.
    _updateCommonAttributes(obj);
    _updateCommonUniforms(obj, camera);

    // Update sprite specific attributes & uniforms.
    if (obj is Sprite) {
      obj.transform.updateModelMatrix();
      _updateSpriteAttributes(obj);
      _updateSpriteUniforms(obj, scene, camera);
    }

    // Update shape's specific attributes.
    if (obj is Shape) {
      obj.rebuildColors();
      _updateShapeAttributes(obj);
    }

    // Fire object render event.
    // Event handler can be defined to handle each object.
    await lifecycleControllers.onObjectRenderCtrl
      ..add(new ObjectRenderEvent(obj, scene, camera, this))
      ..done;
  }

  /// Object post render callback is invoked by [RendererDrawer].
  Future _onObjectPostDraw(SceneObject obj) async {
    // Fire post render event.
    // Event handler can be defined to handle each object after rendering.
    await lifecycleControllers.onObjectPostRenderCtrl
      ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
      ..done;
  }

  /// Update attributes for sprite's shader program.
  void _updateSpriteAttributes(Sprite sprite) {
    updateAttributes({'a_texCoords': sprite.glTextureCoords});
  }

  /// Update uniforms for sprite's shader program.
  void _updateSpriteUniforms(Sprite obj, Scene scene, Camera camera) {
    // Check is lightning available.
    if (obj.normalMap != null && scene.lights.length > 0) {
      // Aggregated lightning uniforms' values.
      List<int> lightsTypes = <int>[];
      List<double> lightsPositions = <double>[];
      List<double> lightsColors = <double>[];
      List<double> lightsFalloffs = <double>[];
      List<double> lightsDirections = <double>[];
      List<double> ambientColor = scene.ambientLight?.color?.toIdentity();

      // Process values.
      for (int i = 0; i < settings.maxLights; i++) {
        Light light =
            (scene.lights.length > i) ? scene.lights.elementAt(i) : null;
        int lightType = 0;
        Vector2 lightPosition = new Vector2.zero();
        SolidColor lightColor = new SolidColor.white();
        Vector3 lightFalloff = new Vector3.zero();
        Vector2 lightDirection = new Vector2.zero();

        if (light == null) break;

        lightColor = light.color;

        if (light is DirectionalLight) {
          lightType = 1;
          lightDirection = light.direction;
        } else if (light is PointLight) {
          lightPosition = light.position;
          lightFalloff = light.falloff;
          lightType = 2;
        }

        // Add in each uniform's value list.
        lightsTypes.add(lightType);
        lightsColors.addAll(lightColor.toIdentity());
        lightsDirections.addAll(lightDirection.storage);
        lightsFalloffs.addAll(lightFalloff.storage);
        lightsPositions.addAll(lightPosition.storage);
      }

      updateUniforms({
        'u_lightPosition': new Float32List.fromList(lightsPositions),
        'u_lightColor': new Float32List.fromList(lightsColors),
        'u_lightFalloff': new Float32List.fromList(lightsFalloffs),
        'u_lightType': new Int8List.fromList(lightsTypes),
        'u_lightDirection': new Float32List.fromList(lightsDirections),
        'u_ambientLightColor':
            ambientColor ?? new SolidColor([0, 0, 0, 0]).toIdentity(),
        'u_useNormalMap': true
      });
    }
  }

  /// Update attributes for shape's shader program.
  void _updateShapeAttributes(Shape obj) {
    updateAttributes({'a_color': obj.glColors});
  }

  /// Update attributes which are common for all shader programs.
  void _updateCommonAttributes(SceneObject obj) {
    updateAttributes({'a_position': obj.glVertices});
  }

  /// Update uniforms which are common for all shader programs.
  void _updateCommonUniforms(SceneObject obj, Camera camera) {
    updateUniforms({
      'u_p': camera.transform.projectionMatrix,
      'u_m': obj.transform.modelMatrix,
      'u_v': camera.transform.viewMatrix
    });
  }

  void _updateLights(Iterable<Light> lights) {
    lights.forEach(_updateLight);
  }

  void _updateLight(Light light) {
    light.update(dt);
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

  void _setFullscreen([_]) =>
      updateViewport(window.innerWidth, window.innerHeight);

  double get dt => _dt;

  int get fps => 1000 ~/ dt;

  Camera get camera => _managers.cameraManager.boundCamera;

  Scene get scene => _managers.sceneManager.boundScene;

  SceneManager get sceneManager => _managers.sceneManager;

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
}
