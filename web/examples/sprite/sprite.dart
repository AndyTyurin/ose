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

  // Logger.
  final Logger logger;

  /// Engine renderer.
  ose.Renderer _renderer;

  /// Canvas element.
  CanvasElement canvas;

  /// Sprite.
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
  // Setup renderer, canvas and delegate event handlers.
  _init() {
    _renderer =
        new ose.Renderer(settings: new ose.RendererSettings(fullscreen: true));
    canvas = _renderer.canvas;
    _renderer.onStart.listen(_onStart);
    _renderer.onStop.listen(_onStop);
  }

  // Handle start event.
  // Prepare scene, camera & sprite for rendering.
  Future _onStart(ose.StartEvent e) async {
    logger.fine('Example has been started.');

    ose.Scene scene = _renderer.scene = new ose.Scene();
    ose.Camera camera =
        _renderer.camera = new ose.Camera(canvas.width, canvas.height);

    // Resource loader is needed to get game resources.
    ose.ResourceLoader resourceLoader = new ose.ResourceLoader();

    // When new file loaded.
    resourceLoader.onLoad.listen((e) {
      print('Resource loaded by path ${e.path}');
    });

    /// Listen for file progress loading.
    resourceLoader.onProgress.listen((e) {
      if (e.lengthComputable) {
        print('Loaded ${e.loaded} / ${e.total} bytes by path ${e.path}');
      } else {
        print('Loaded ${e.loaded} bytes by path ${e.path}');
      }
    });

    /// Output loading errors.
    resourceLoader.onError.listen((e) {
      print(e.error.toString());
    });

    /// Map key alias.
    const String SPACESHIP = 'spaceship';

    /// Load and register textures in asset manager to use them.
    _renderer.assetManager.registerTextures({
        "${SPACESHIP}":
          await resourceLoader.loadTexture('/examples/sprite/spaceship.png')
    });


    /// Grab texture from asset manager.
    ose.Texture spaceshipTexture = _renderer.assetManager.textures[SPACESHIP];

    /// Create a new sprite with texture and actor logic.
    Spaceship spaceship = new Spaceship();
    spaceship.transform.scale.setValues(.5, .5);
    spaceship.actor = new PlayerActor();
    spaceship.texture = spaceshipTexture;

    // Create & add lightning to scene.
    ose.DirectionalLight directionalLight = new ose.DirectionalLight();
    scene.add(directionalLight);

    // Add sprite to scene.
    scene.add(spaceship);
  }

  // Handle stop event.
  void _onStop(ose.StopEvent e) {
    logger.fine('Game has been stopped');
  }

  // Flush resources to reload fresh on start.
  _flushResources() {
    _spaceship = null;
    canvas = null;
    _renderer = null;
  }
}

/// Spaceship sprite.
class Spaceship extends ose.Sprite {
  static double rotationAcceleration = .003;
  static double rotationDamping = .004;
  double rotationSpeed = .0;
  bool isLeftRotation = false;
  bool isRightRotation = false;
  bool isBreak = false;

  @override
  void update(num dt) {
    if (isBreak) {
      rotationSpeed = .0;
    } else {
      if (isRightRotation) {
        rotationSpeed += rotationAcceleration;
      } else if (isLeftRotation) {
        rotationSpeed -= rotationAcceleration;
      } else {
        double rotationSign = rotationSpeed.sign;
        rotationSpeed = rotationSpeed.abs() - rotationDamping;
        if (rotationSpeed < .0) {
          rotationSpeed = .0;
        } else {
          rotationSpeed *= rotationSign;
        }
      }
    }

    transform.rotation += rotationSpeed / 100 * dt;

    isLeftRotation = false;
    isRightRotation = false;
    isBreak = false;
  }

  void rotateRight() {
    isRightRotation = true;
  }

  void rotateLeft() {
    isLeftRotation = true;
  }

  void breakSpeed() {
    isBreak = true;
  }
}

/// Actor to manage [Spaceship].
class PlayerActor extends ose.ControlActor {
  @override
  void update(ose.Scene scene, ose.SceneObject spaceship,
      [IOManager ioManager]) {
    KeyboardController keyboard = ioManager.keyboard;
    MouseController mouse = ioManager.mouse;
    TouchController touch = ioManager.touch;

    if (spaceship is Spaceship) {
      if (keyboard.pressed(KeyCode.D) ||
          mouse.movedRight && mouse.pressed(0) ||
          touch.movedRight) {
        spaceship.rotateRight();
      }
      if (keyboard.pressed(KeyCode.A) ||
          mouse.movedLeft && mouse.pressed(0) ||
          touch.movedLeft) {
        spaceship.rotateLeft();
      }
      if (keyboard.pressed(KeyCode.W, ctrl: true)) {
        spaceship.breakSpeed();
      }
    }
  }
}

/// Launch.
void main() {
  initLogger();
  SpriteExample example = new SpriteExample();
  document.documentElement.append(example.canvas);
  example.start();
}
