import 'dart:html' hide Rectangle;
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:ose/ose.dart';
import 'package:ose/ose_webgl.dart' as osegl;
import 'package:ose/ose_math.dart';

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
  CanvasElement canvas = new CanvasElement();
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  // Append canvas to DOM.
  document.body.append(canvas);

  // Initialize renderer.
  osegl.WebGLRenderer renderer = new osegl.WebGLRenderer(
      canvas: canvas, rendererSettings: new RendererSettings());

  window.addEventListener('resize', (_) {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
      renderer.updateViewport();
  });

  // Initialize scene & camera.
  Scene scene = new Scene();
  Camera camera = new Camera(canvas.width, canvas.height);
  camera.transform.position = new Vector2(0.0, 0.0);
  //camera.transform.scale = 5;
  // Initialize scene objects.
  // oseGL.Rectangle rectangle = new oseGL.Rectangle();
  // rectangle.transform.scale = new Vector2(.25, .25);
  // scene.children.add(rectangle);
  //
  // oseGL.Triangle triangle = new oseGL.Triangle();
  // triangle.transform.scale = new Vector2(.25, .25);
  // scene.children.add(triangle);
  //
  // const int numOfCircles = 15;
  //
  // oseGL.Circle patternCircle = new oseGL.Circle(6);
  //
  math.Random random = new math.Random();
  // double prevScaleFactor = 1.0;
  // double prevPositionFactor = 1.0;
  // for (int i = 0; i < numOfCircles; i++) {
  //   oseGL.Circle circle = patternCircle.clone();
  //   double scaleFactor = math.max(.1, random.nextDouble());
  //   int sign = (random.nextDouble() > .5) ? 1 : -1;
  //   double positionFactor =
  //       (prevPositionFactor.abs() + scaleFactor + prevScaleFactor) +
  //           random.nextDouble() / 1.5;
  //   circle.transform.scale = new Vector2(scaleFactor, scaleFactor);
  //   circle.transform.position =
  //       new Vector2(sign * (positionFactor), sign * (positionFactor));
  //   prevScaleFactor = scaleFactor;
  //   prevPositionFactor = positionFactor;
  //   scene.children.add(circle);
  // }

  osegl.Triangle triangle = new osegl.Triangle();
  triangle.transform.scale = new Vector2(.5, .5);
  triangle.color = new GradientColor([
    new Color([255, 0, 0, 255]),
    new Color([0, 255, 0, 255]),
    new Color([0, 0, 255, 255])
  ]);
  //triangle.color = new SolidColor(new Color([255, 255, 255, 255]));
  scene.children.add(triangle);

  // Link life-cycle handlers to renderer.
  renderer.onStart.listen((StartEvent e) {
    renderer.scene = scene;
    renderer.camera = camera;
    logger.fine('Renderer started');
  });

  renderer.onStop.listen((StopEvent e) {
    logger.fine('Renderer stopped');
  });

  // List<double> velocities = <double>[];
  // for (int i = 0; i < numOfCircles; i += 1) {
  //   velocities.add(math.max(.005, random.nextDouble() / 100));
  // }

  var j = 1;
  renderer.onRender.listen((RenderEvent e) {
    for (int i = 0; i < e.scene.children.length; i++) {
      GameObject obj = e.scene.children[i];
      if (obj is osegl.Circle) {
        // Vector2 position = obj.transform.position;
        // double translationFactor = velocities[i];
        // obj.transform.position = new Vector2(
        //     position.x * math.cos(translationFactor) -
        //         position.y * math.sin(translationFactor),
        //     position.x * math.sin(translationFactor) +
        //         position.y * math.cos(translationFactor));
      } else if (obj is osegl.Triangle) {
        obj.transform.rotation += 0.01;
        if (j % 2 == 0) {
          obj.color.colors[0] = new Color.fromIdentity([
            random.nextDouble(),
            random.nextDouble(),
            random.nextDouble(),
            1.0
          ]);
        }
        if (j % 4 == 0) {
          obj.color.colors[1] = new Color.fromIdentity([
            random.nextDouble(),
            random.nextDouble(),
            random.nextDouble(),
            1.0
          ]);
        }
        if (j % 8 == 0) {
          obj.color.colors[2] = new Color.fromIdentity([
            random.nextDouble(),
            random.nextDouble(),
            random.nextDouble(),
            1.0
          ]);
        }
      }
    }
    j++;
  });

  renderer.onObjectRender.listen((ObjectRenderEvent e) {});

  renderer.start();
}
