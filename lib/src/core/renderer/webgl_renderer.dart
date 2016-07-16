part of ose;

class WebGLRenderer {
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
      int width: 800,
      int height: 600,
      bool transparent: true,
      bool antialias: true,
      bool preserveDrawingBuffer: false}) {
    // Create rendering context.
    _gl = _createWebGL(
        canvas, width, height, transparent, antialias, preserveDrawingBuffer);

    // Initialize on start stream controller.
    _onStartController = new StreamController.broadcast(sync: true);
    _onStart = _onStartController.stream;

    // Initialize on stop stream controller.
    _onStopController = new StreamController.broadcast(sync: true);
    _onStop = _onStopController.stream;

    // Initialize on tick stream controller.
    _onTickController = new StreamController.broadcast(sync: true);
    _onTick = _onTickController.stream;

    // Initialize on scene change stream controller.
    _onSceneController = new StreamController.broadcast(sync: true);
    _onSceneChange = _onSceneController.stream;

    // Initialize timer.
    _timer = new utils.Timer();

    _fps = 0;

    _fpsThreshold = 0;

    // Initialize WebGL.
    _initWebGL();
  }

  /// Launch renderer.
  Future start(Scene scene, {int fps: 60}) async {
    // Checks WebGL is available.
    if (_gl == null) throw new UnsupportedError(webglContextIsNotSupported);

    // Set an active scene.
    this.scene = scene;

    // Waits while all listeners done their works & then release controller.
    if (_onStartController.hasListener) {
      await _onStartController
        ..add(this)
        ..done;
    }

    // Setup fps threshold (in ms).
    _fpsThreshold = 1000 / (60 - math.max(1, math.min(60, fps)));

    _dt = 0.0;

    // Preparations before render.
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(webGL.COLOR_BUFFER_BIT | webGL.DEPTH_BUFFER_BIT);

    // Initialize first timestamp.
    _timer.checkpoint();
    _timer.flush();

    window.animationFrame.then((_) => render(_fpsThreshold));
  }

  /// Request to stop renderer.
  Future stop() async {
    _isRenderStopRequested = true;

    // Waits while all listeners done their work & release controller.
    if (_onStopController.hasListener) {
      await _onStopController
        ..add(this)
        ..done;
    }
  }

  /// Rendering loop.
  render(_) async {
    if (!_isRenderStopRequested) {
      window.animationFrame.then(render);

      _timer.checkpoint();

      // Skip frame if fps threshold was reached.
      if (_timer.accumulator >= _fpsThreshold) {
        _timer.reset(_fpsThreshold);
        return;
      }

      /**
       * Rendering code here.
       */

      _renderScene(scene);

      // Check if new scene requested.
      if (_sceneToLoad != null) {
        _scene = _sceneToLoad;
        _sceneToLoad = null;
      }

      // Callback on each tick.
      // Used to reset clear unused data.
      if (_onTickController.hasListener) {
        await _onTickController
          ..add(this)
          ..done;
      }
    }
  }

  /// Render scene.
  void _renderScene(Scene scene) {
    if (scene == null) {
      _handleRenderError("Renderer couldn't find a scene to render");
      return;
    }

    if (scene.camera == null) {
      _handleRenderError("Renderer couldn't find a camera applied to scene");
    }

    // Clear color, depth and stencil buffers.
    gl.clear(webGL.COLOR_BUFFER_BIT |
        webGL.DEPTH_BUFFER_BIT |
        webGL.STENCIL_BUFFER_BIT);

    // Iterate objects of the scene to render.
    scene.objects.forEach((obj) {
      // Update object's transformation model matrix.
      obj.transform.updateModelMatrix();

      // Apply filter.
      if (obj is FilterMixin) {
        if (obj.filter != null) {
          obj.filter.apply(scene, obj as GameObject);
        } else {
          // TODO: Apply basic filter.
        }
      }

      // Draw object.
      gl.drawArrays(webGL.TRIANGLE_STRIP, 0,
          ((obj as VerticesMixin).vertices.length ~/ 2));
    });
  }

  /// Handle render error.
  ///
  /// Stop renderer and throw an error if something happens while rendering.
  void _handleRenderError(String msg) {
    stop();
    return _handleError(msg);
  }

  /// Handle common error.
  ///
  /// Handle different errors by simplify throwing them.
  void _handleError(String msg) {
    return throw new StateError(msg);
  }

  /// Create canvas & WebGL rendering context.
  webGL.RenderingContext _createWebGL(
      [canvas, width, height, transparent, antialias, preserveDrawingBuffer]) {
    _canvas = (canvas != null)
        ? canvas
        : new CanvasElement(width: width, height: height);

    // Append canvas element.
    window.document.documentElement.append(_canvas);

    _gl = _canvas.getContext3d(
        alpha: transparent,
        premultipliedAlpha: transparent,
        antialias: antialias,
        stencil: true,
        preserveDrawingBuffer: preserveDrawingBuffer);

    if (_gl == null) {
      window.console.warn(webglContextIsNotSupported);
    }

    return _gl;
  }

  /// Initialize WebGL.
  void _initWebGL() {
    // Disable depth.
    _gl.disable(webGL.DEPTH_TEST);

    // Disable stencil.
    _gl.disable(webGL.STENCIL_TEST);

    // Enable blend.
    _gl.enable(webGL.BLEND);
    _gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);

    // Set default 'black' clear color.
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);
    _gl.clear(webGL.COLOR_BUFFER_BIT);
  }

  void set scene(Scene scene) {
    if (_scene == null) {
      _scene = scene;
    } else {
      _sceneToLoad = scene;
    }
  }

  Scene get scene => _scene;

  CanvasElement get canvas => _canvas;

  webGL.RenderingContext get gl => _gl;

  Stream get onStart => _onStart;

  Stream get onStop => _onStop;

  Stream get onTick => _onTick;

  Stream get onSceneChange => _onSceneChange;

  int get fps => _fps;

  double get dt => dt;
}
