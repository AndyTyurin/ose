library ose_example_sprite;

import 'dart:html';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:ose/ose.dart' as ose;
import '../../index.dart' show initLogger;

class SpriteExample {
  static final FRAMES_PER_SECOND = 60;

  final Logger logger;

  ose.Renderer _renderer;

  CanvasElement canvas;

  ose.Sprite _sprite;

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

  // Initialize basic renderer eco-system.
  // Create a new renderer, to setup canvas, initialize camera
  // and delegate event handlers.
  _init() {
    _renderer = new ose.Renderer();
    canvas = _renderer.canvas;
    _renderer.scene = new ose.Scene();
    _renderer.camera = new ose.Camera(canvas.width, canvas.height);
    _renderer.onStart.listen(_onStart);
    _renderer.onStop.listen(_onStop);
    _renderer.onRender.listen(_onRender);
  }

  // Prepare sprite.
  // Load image, build a texture and apply it to sprite object.
  Future _prepareSprite() async {
    _sprite = new ose.Sprite();
    ImageElement img = new ImageElement(src: '/examples/sprite/spaceship.png');
    try {
      await img.onLoad.listen((_) => _renderer.scene.children
          .add(_sprite..setActiveTexture(new ose.Texture(img))));
    } catch (e) {
      _handleSevereError(new Exception('Image not found'));
    }
  }

  // Handle start event.
  // Prepares sprite for renderer.
  Future _onStart(ose.StartEvent e) async {
    logger.fine('Game has been started.');
    await _prepareSprite();
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
    _sprite = null;
    canvas = null;
    _renderer = null;
  }

  // Handle frame before it will be rendered.
  _onRender(ose.RenderEvent e) {
    e.scene.children.forEach((ose.SceneObject obj) {
      obj.transform.rotation += 0.01;
    });
  }
}

void main() {
  initLogger();
  SpriteExample se = new SpriteExample();
  document.documentElement.append(se.canvas);
  se.start();
}
