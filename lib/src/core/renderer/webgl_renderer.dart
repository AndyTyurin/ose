library ose.core.renderer;

import 'dart:html';
import 'dart:async';
import 'dart:math' as math;
import 'dart:web_gl' as webGL;

import 'package:ose/src/utils/utils.dart' as utils;

import './../scene/scene_manager.dart';
import './../scene/scene.dart';

class WebGLRenderer {
  static const String webglContextIsNotSupported = 'WebGL is not supported';

  /// Canvas element.
  CanvasElement _canvas;

  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  /// Render stop requested flag.
  ///
  /// Stops rendering ASAP when flag is [true].
  bool _isRenderStopRequested = false;

  /// Top threshold for fps (1-60 frames per second);
  int _fpsThreshold = 60;

  /// Scene manager.
  ///
  /// Gives ability to manage scene, set one of them to be an active
  /// and switch between either available.
  SceneManager _sceneManager;

  /// Timer.
  ///
  /// Mainly used to calculate delta time.
  utils.Timer _timer;

  /// Stream controller to manage [onStart] stream.
  StreamController<WebGLRenderer> _onStartController;

  /// Stream controller to manage [onStop] stream.
  StreamController<WebGLRenderer> _onStopController;

  /// Emits when renderer starts work.
  Stream<WebGLRenderer> _onStart;

  /// Emits when renderer stops work.
  Stream<WebGLRenderer> _onStop;

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

    // Initialize scene manager.
    _sceneManager = new SceneManager();

    // Initialize on start stream controller.
    _onStartController = new StreamController.broadcast(sync: true);
    _onStart = _onStartController.stream;

    // Initialize on stop stream controller.
    _onStopController = new StreamController.broadcast(sync: true);
    _onStop = _onStopController.stream;

    // Initialize timer.
    _timer = new utils.Timer();

    // Initialize WebGL.
    _initWebGL();
  }

  /// Launch renderer.
  Future start(String sceneName,
      {int fps: 60, Future onStart(WebGLRenderer renderer)}) async {
    // Checks WebGL is available.
    if (_gl == null) throw new UnsupportedError(webglContextIsNotSupported);

    // Set active scene.
    sceneManager.setActive(sceneName);

    // Setup fps threshold.
    _fpsThreshold = math.max(1, math.min(60, fps));

    // Re-initialize on stop stream controller.
    if (_onStopController == null) {
      _onStopController = new StreamController.broadcast(sync: true);
      _onStop = _onStopController.stream;
    }

    // Waits while all listeners done their works & then release controller.
    await _onStartController..add(this)..done..close();

    window.animationFrame.then(render);
  }

  /// Request to stop renderer.
  Future stop() async{
    _isRenderStopRequested = true;

    // Re-initialize on start stream controller.
    if (_onStartController == null) {
      _onStartController = new StreamController.broadcast(sync: true);
      _onStart = _onStartController.stream;
    }

    // Waits while all listeners done their work & release controller.
    await _onStopController..add(this)..done..close();
  }

  /// Rendering loop.
  render(num dt) {
    // Fps threshold.
    if (_timer.checkpoint() > 1 / _fpsThreshold) {
      window.console.log((1 / _timer.delta).toString() + ' fps');
      if (!_isRenderStopRequested) window.animationFrame.then(render);
    }
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

  CanvasElement get canvas => _canvas;

  webGL.RenderingContext get gl => _gl;

  SceneManager get sceneManager => _sceneManager;

  Stream get onStart => _onStart;

  Stream get onStop => _onStop;
}
