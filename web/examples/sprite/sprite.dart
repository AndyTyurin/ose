library ose_example_sprite;

import 'dart:html';
import 'dart:math' as math;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:ose/ose.dart' as ose;
import 'package:ose/ose_io.dart';

import '../../index.dart' show initLogger;

class SpriteExample {
  static final FRAMES_PER_SECOND = 60;

  final Logger logger;

  ose.Renderer _renderer;

  CanvasElement canvas;

  Spaceship _spaceship;

  SpriteExample() : logger = new Logger('Sprite example') {
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
  // Create a new renderer, setup canvas, initialize camera
  // and delegate event handlers.
  _init() {
    _renderer =
        new ose.Renderer(settings: new ose.RendererSettings(fullscreen: true));
    canvas = _renderer.canvas;
    _renderer.onStart.listen(_onStart);
    _renderer.onStop.listen(_onStop);
    _renderer.onObjectRender.listen(_onObjectRender);
  }

  // Prepare sprite.
  // Load image, build a texture and apply it to sprite object.
  Future _prepareSpaceship() async {
    _spaceship = new Spaceship();
    _spaceship.actor = new PlayerActor();

    ImageElement img = new ImageElement(src: '/examples/sprite/spaceship.png');
    try {
      await img.onLoad.listen((_) => _renderer.scene.children
          .add(_spaceship..setActiveTexture(new ose.Texture(img))));
    } catch (e) {
      _handleSevereError(new Exception('Image not found'));
    }
  }

  // Handle start event.
  // Prepares sprite for renderer.
  Future _onStart(ose.StartEvent e) async {
    logger.fine('Example has been started.');

    _renderer.scene = new ose.Scene();
    _renderer.camera = new ose.Camera(canvas.width, canvas.height);

    // Register your custom filters.
    // _renderer.registerFilters(filters);

    // await _prepareSpaceship();
    ose.Rectangle rect = new ose.Rectangle();
    rect.transform.rotation = math.PI / 4;

    ose.Circle circle = new ose.Circle(points: 6);
    circle.color = new ose.SolidColor.red();
    circle.transform.scale.setValues(.75, .75);

    _renderer.scene.add(rect);
    _renderer.scene.add(circle);
  }

  // Handle stop event.
  void _onStop(ose.StopEvent e) {
    logger.fine('Game has been stopped');
  }

  // Stop renderer with severe error.
  _handleSevereError(Exception e) {
    logger.severe(e);
    stop();
  }

  // Flush resources to reload fresh on start.
  _flushResources() {
    _spaceship = null;
    canvas = null;
    _renderer = null;
  }

  // Handle frame before it will be rendered.
  _onObjectRender(ose.ObjectRenderEvent e) {
    ose.SceneObject obj = e.sceneObject;
    if (obj is ose.Circle) {
      obj.transform.rotation += 0.002;
    } else if (obj is ose.Rectangle) {
      obj.transform.rotation -= 0.004;
    } else {
      obj.transform.rotation += 0.001;
    }
  }
}

class Spaceship extends ose.Sprite {
  double rotationAcceleration = .0;

  @override
  void update(num dt) {
    transform.rotation += rotationAcceleration;
  }
}

class PlayerActor extends ose.ControlActor {
  @override
  void update(ose.Scene scene, ose.SceneObject sceneObject,
      [IOManager ioManager]) {
    KeyboardController keyboard = ioManager.keyboard;
    MouseController mouse = ioManager.mouse;
    TouchController touch = ioManager.touch;

    if (sceneObject is Spaceship) {
      if (keyboard.pressed(KeyCode.D) ||
          mouse.movedRight && mouse.pressed(0) ||
          touch.movedRight) {
        sceneObject.transform.rotation += 0.075;
      }
      if (keyboard.pressed(KeyCode.A) ||
          mouse.movedLeft && mouse.pressed(0) ||
          touch.movedLeft) {
        sceneObject.transform.rotation -= 0.075;
      }
      if (keyboard.pressed(KeyCode.W, ctrl: true)) {
        sceneObject.transform.rotation = .0;
      }
    }
  }
}

void main() {
  initLogger();
  SpriteExample se = new SpriteExample();
  document.documentElement.append(se.canvas);
  se.start();
}
