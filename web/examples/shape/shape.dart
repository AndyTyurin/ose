library ose_example_sprite;

import 'dart:html';
import 'dart:math' as math;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:ose/ose.dart' as ose;
import 'package:ose/ose_io.dart';

import '../../index.dart' show initLogger;

class ShapeExample {
  static final FRAMES_PER_SECOND = 60;

  // Logger.
  final Logger logger;

  /// Engine renderer.
  ose.Renderer _renderer;

  /// Canvas element.
  CanvasElement canvas;

  ShapeExample() : logger = new Logger('Sprite example') {
    _init();
  }

  // Start renderer & allocate resources.
  start() {
    _renderer.start();
  }

  // Stop renderer & flush resources.
  stop() {
    _renderer.stop();
    _flushResources();
  }

  // Initialize basic renderer system.
  // Setup renderer, canvas and delegate event handlers.
  _init() {
    _renderer =
        new ose.Renderer(settings: new ose.RendererSettings(fullscreen: true));
    canvas = _renderer.canvas;
    _renderer.onStart.listen(_onStart);
    _renderer.onStop.listen(_onStop);
    _renderer.onObjectRender.listen(_onObjectRender);
  }

  // Handle start event.
  // Prepare scene, camera & sprite for rendering.
  Future _onStart(ose.StartEvent e) async {
    logger.fine('Example has been started.');

    ose.Scene scene = _renderer.scene = new ose.Scene();
    ose.Camera camera =
        _renderer.camera = new ose.Camera(canvas.width, canvas.height);

    // Create shapes.
    ose.Triangle triangle = new ose.Triangle(color: new ose.SolidColor.red());
    ose.Rectangle rectangle = new ose.Rectangle(color: new ose.SolidColor.blue());
    ose.Circle circle = new ose.Circle(color: new ose.SolidColor.green());

    triangle.transform.position.x = -1.5;
    triangle.transform.scale.setValues(.4, .4);
    rectangle.transform.position.x = .0;
    rectangle.transform.scale.setValues(.4, .4);
    circle.transform.position.x = 1.5;
    circle.transform.scale.setValues(.4, .4);

    // Add sprite to scene.
    scene.add(triangle);
    scene.add(rectangle);
    scene.add(circle);
  }

  // Handle stop event.
  void _onStop(ose.StopEvent e) {
    logger.fine('Game has been stopped');
  }

  void _onObjectRender(ose.ObjectRenderEvent e) {
    e.sceneObject.transform.rotation += 0.0005 * _renderer.dt;
  }

  // Flush resources to reload fresh on start.
  _flushResources() {
    canvas = null;
    _renderer = null;
  }
}

/// Launch.
void main() {
  initLogger();
  ShapeExample example = new ShapeExample();
  document.documentElement.append(example.canvas);
  example.start();
}
