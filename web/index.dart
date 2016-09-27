import 'dart:html' hide Rectangle;
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:ose/ose.dart';
import 'package:ose/ose_math.dart';

class Character extends Sprite {

}

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
  canvas.width = window.document.documentElement.clientWidth;
  canvas.height = window.document.documentElement.clientHeight;

  // Append canvas to DOM.
  document.body.append(canvas);

  // Initialize renderer.
  Renderer renderer =
      new Renderer(canvas: canvas, settings: new RendererSettings());

  window.addEventListener('resize', (_) {
    renderer.updateViewport(canvas.width, canvas.height);
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
  //math.Random random = new math.Random();
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
  // Rectangle rectangle = new Rectangle();
  // rectangle.transform.scale = new Vector2(.75, .75);
  // scene.children.add(rectangle);
  // Triangle triangle = new Triangle();
  // triangle.transform.scale = new Vector2(.5, .5);
  //Triangle triangle2 = new Triangle();
  //triangle2.transform.scale = new Vector2(.5, .5);
  //triangle2.transform.rotation = math.PI;

  //Rectangle rect = new Rectangle();

  //Circle circle = new Circle(10);
  // scene.children.add(rect);
  // scene.children.add(triangle);
  // scene.children.add(triangle);

  // Triangle triangle3 = new Triangle();
  // triangle3.transform.scale = new Vector2(.5, .5);
  // triangle3.transform.rotation = -math.PI / 4;
  // triangle.color = new GradientColor([
  //   new Color([255, 0, 0, 255]),
  //   new Color([0, 255, 0, 255]),
  //   new Color([0, 0, 255, 255])
  // ]);
  //triangle.color = new SolidColor(new Color([255, 255, 255, 255]));

  //scene.children.add(triangle2);
  // scene.children.add(triangle3);

  // TODO: Load image by another way.
  ImageElement image = new ImageElement(src: '/i/character.png');
  image.onLoad.listen((e) {
    Texture texture = new Texture(image);
    SubTexture characterBottom = texture.createSubTexture(new Rect(10, 5, 100, 120));
    Character character = new Character();
    Rectangle rectangle = new Rectangle();
    scene.children.add(rectangle);
    character.setActiveSubTexture(characterBottom);
    // character.setActiveTexture(texture);
    character.transform.scale = new Vector2(4.0, 4.0);
    // ss.transform.rotation = math.PI / 2;

    // Triangle triangle = new Triangle();
    // triangle.transform.scale = new Vector2(0.25, 0.25);
    // scene.children.add(triangle);

    scene.children.add(character);

    // Circle circle = new Circle(10);
    // scene.children.add(circle);

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

    //var j = 1;
    renderer.onRender.listen((RenderEvent e) {
      // for (int i = 0; i < e.scene.children.length; i++) {
      //   SceneObject obj = e.scene.children[i];
      //   if (obj is Rectangle) {
      //     //obj.transform.rotation -= 0.01;
      //   } else if (obj is Triangle) {
      //     //obj.transform.rotation += 0.01;
      //
      //   }
      // }
      // j++;
      //
    });

    renderer.onObjectRender.listen((ObjectRenderEvent e) {
        // e.sceneObject.transform.rotation += 0.01;
    });

    renderer.start();
  });
}
