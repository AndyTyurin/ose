import 'dart:html' hide Rectangle;

import 'package:logging/logging.dart';
import 'package:ose/ose.dart';

main() async {
  // Set logger settings.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    Level level = rec.level;
    // Colorize & set state for logging.
    if (level == Level.INFO) {
      window.console.log('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else if (level == Level.SEVERE) {
      window.console.error('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else if (level == Level.WARNING || level == Level.SHOUT) {
      window.console.warn('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      window.console.debug('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });

  // Create logger.
  Logger logger = new Logger('Example');

  // Create canvas.
  CanvasElement canvas = new CanvasElement(
      width: 800,
      height: 445);

  // Append canvas to DOM.
  document.documentElement.append(canvas);

  // Initialize engine.
  Ose ose = new Ose();
  WebGLRenderer renderer = await ose.createWebGLRenderer(
      canvas: canvas, width: canvas.width, height: canvas.height);


  // Link life-cycle handlers to renderer.
  renderer.onStart.listen((_) {
    logger.fine('Renderer started');
  });

  renderer.onStop.listen((_) {
    logger.fine('Renderer stopped');
  });

  double rad = 0.05;

  //math.Random random = new math.Random();

  renderer.onTick.listen((WebGLRenderer renderer) {
    //logger.fine("${renderer.fps} FPS");
    // very ugly rotation.
/*    for (var i=0; i<10000; i+=1) {
      var obj = renderer.scene.objects[0].children[i];

      if (obj != null) {
        var clockwise = (i % 2) ? 1 : -1;
        obj.transform.rotateBy(clockwise * rad / obj.transform.scale.length());
      }
    }*/
  });

  // Create scene.
  Scene scene = new Scene();

  // Create camera.
  Camera camera = new Camera(canvas.width.toDouble(), canvas.height.toDouble(), 1.0);

  // Apply an active camera to scene.
  scene.camera = camera;

  // Create a new texture.
  //Texture texture = await ose.textureManager.load('i/bunny02.png');

  BasicFilter filter = new BasicFilter();

  Rectangle rectangle = new Rectangle();
  rectangle.filter = filter;
  rectangle.transform.translateBy(-3.0, 0.0);

  Triangle triangle = new Triangle();
  triangle.filter = filter;
  triangle.transform.translateBy(3.0, 0.0);

  scene.add(rectangle);
  scene.add(triangle);

/*  GameObject gameContainer = new GameObject(filter: filter, texture: texture);

  // Add 10000 spaceships to scene.
  for (var i=0; i<10000; i+=1) {
    double posX = random.nextDouble() * random.nextInt(12) - 6;
    double posY = random.nextDouble() * random.nextInt(6) - 2.5;
    double scale = random.nextDouble() * random.nextInt(2);

    // Create spaceship, apply texture & set position.
    GameObject spaceship = new GameObject(texture: texture, filter: filter);
    spaceship.transform.position = new Vector2(posX, posY);
    spaceship.transform.scale = new Vector2(0.15, 0.15);

    // Add object to scene.
    gameContainer.add(spaceship);
  }

  scene.add(gameContainer);*/




  // Start rendering the scene. Manage your fps from 0 - 60 for debug.
  await renderer.start(scene, fps: 1);

}
