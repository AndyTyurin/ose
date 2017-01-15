library ose_example_sprite;

import 'dart:html';
import 'dart:math' as math;
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:ose/ose.dart' as ose;
import 'package:ose/ose_io.dart';
import 'package:ose/ose_math.dart';

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
    _renderer.onObjectRender.listen(_onObjectRender);
    _renderer.onRender.listen(_onRender);
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
    const String SPACESHIP_COLOR_MAP = 'spaceship_color_map';
    const String SPACESHIP_NORMAL_MAP = 'spaceship_normal_map';
    const String SPACESHIP_COLOR_MAP1 = 'spaceship_color_map1';
    const String SPACESHIP_NORMAL_MAP1 = 'spaceship_normal_map1';

    /// Load and register textures in asset manager to use them.
    _renderer.assetManager.registerTextures({
      "${SPACESHIP_COLOR_MAP1}":
          await resourceLoader.loadTexture('/examples/sprite/ss1.png'),
      "${SPACESHIP_NORMAL_MAP1}":
          await resourceLoader.loadTexture('/examples/sprite/ss1_normal2.png'),
      "${SPACESHIP_COLOR_MAP}":
          await resourceLoader.loadTexture('/examples/sprite/ss1.png'),
      "${SPACESHIP_NORMAL_MAP}":
          await resourceLoader.loadTexture('/examples/sprite/ss1_normal.png')
    });

    /// Grab texture from asset manager.
    ose.Texture spaceshipColorTexture =
        _renderer.assetManager.textures[SPACESHIP_COLOR_MAP];
    ose.Texture spaceshipNormalTexture =
        _renderer.assetManager.textures[SPACESHIP_NORMAL_MAP];
    ose.Texture spaceshipColorTexture1 =
        _renderer.assetManager.textures[SPACESHIP_COLOR_MAP1];
    ose.Texture spaceshipNormalTexture1 =
        _renderer.assetManager.textures[SPACESHIP_NORMAL_MAP1];

    /// Create a new sprite with texture and actor logic.
    Spaceship spaceship = new Spaceship();
    spaceship.actor = new PlayerActor();
    spaceship.transform.scale.setValues(.5, .5);
    spaceship.colorMap = spaceshipColorTexture;
    spaceship.normalMap = spaceshipNormalTexture;
    Spaceship spaceship1 = new Spaceship();
    spaceship1.transform.scale.setValues(.5, .5);
    spaceship1.transform.position.setValues(2.0, 0.0);
    spaceship1.colorMap = spaceshipColorTexture;
    spaceship1.normalMap = spaceshipNormalTexture;

    // Create & add lightning to scene.
    ose.DirectionalLight directionalLight = new ose.DirectionalLight(
        direction: new Vector2(0.0, 1.0),
        color: new ose.SolidColor.white()..alpha = 255);
    ose.AmbientLight ambientLight =
        new ose.AmbientLight(color: new ose.SolidColor.white()..alpha = 15);
    ose.PointLight pointLight = new ose.PointLight(color: new ose.SolidColor.green(), falloff: new Vector3(.4, 1.5, 10.0));
    pointLight.position.setValues(1.0, 0.0);
    scene.add(ambientLight);
    scene.add(directionalLight);
    scene.add(pointLight);
    scene.add(spaceship);
    scene.add(spaceship1);

    _spaceship = spaceship;
  }

  // Handle stop event.
  void _onStop(ose.StopEvent e) {
    logger.fine('Game has been stopped');
  }

  void _onObjectRender(ose.ObjectRenderEvent e) {
    if (e.sceneObject.actor == null) {
      e.sceneObject.transform.rotation += 0.01;
    }
  }

  void _onRender(ose.RenderEvent e) {
    // if (_spaceship != null) {
    //   e.camera.transform.rotation += 0.01;
    // }
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
  static double acceleration = .01;
  static double damping = .005;
  double rotationSpeed = .0;
  double speed = .0;
  bool isLeftRotation = false;
  bool isRightRotation = false;
  bool isMoveForward = false;
  bool isMoveBackward = false;

  @override
  void update(num dt) {
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

    if (isMoveForward) {
      speed += acceleration;
    } else if (isMoveBackward) {
      speed -= acceleration;
    } else {
      double moveSign = speed.sign;
      speed = speed.abs() - damping;
      if (speed < .0) {
        speed = .0;
      } else {
        speed *= moveSign;
      }
    }

    transform.rotation += rotationSpeed / 100 * dt;
    transform.position += transform.forward * (speed / 100 * dt);

    isLeftRotation = false;
    isRightRotation = false;
    isMoveForward = false;
    isMoveBackward = false;
  }

  void rotateRight() {
    isRightRotation = true;
  }

  void rotateLeft() {
    isLeftRotation = true;
  }

  void moveForward() {
    isMoveForward = true;
  }

  void moveBackward() {
    isMoveBackward = true;
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
      if (keyboard.pressed(KeyCode.W)) {
        spaceship.moveForward();
      }
      if (keyboard.pressed(KeyCode.S)) {
        spaceship.moveBackward();
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
