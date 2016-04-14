import 'dart:html';

import 'package:ose/ose.dart';

main() async {
  // Create canvas.
  CanvasElement canvas = new CanvasElement(
      width: document.documentElement.clientWidth,
      height: document.documentElement.clientHeight);

  // Append canvas to DOM.
  document.documentElement.append(canvas);

  // Initialize engine.
  Ose ose = new Ose(canvas: canvas, width: canvas.width, height: canvas.height);
  WebGLRenderer renderer = ose.renderer;

  // Create scene.
  SceneManager sceneManager = renderer.sceneManager;
  Scene scene = sceneManager.create('scene_01');

  // Start rendering the scene. Manage your fps from 0 - 60 for debug.
  renderer.start('scene_01', fps: 60);
}
