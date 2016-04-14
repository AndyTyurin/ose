import 'dart:html';

import 'package:ose/src/utils/uuid.dart';

import './../object/game_object.dart';
import './../camera/camera_manager.dart';

class Scene {
  /// Unique id.
  String _uuid;

  /// Camera manager.
  ///
  /// Manages scene cameras to give access to an active of list of
  /// available cameras.
  CameraManager _cameraManager;

  /// Game objects.
  ///
  /// There are mainly used by renderer to show off on a screen.
  List<GameObject> _objects;

  Scene() {
    _uuid = generateUuid();
    _cameraManager = new CameraManager();
    _objects = <GameObject>[];
  }

  /// Add game object to scene.
  void add(GameObject obj) {
    _objects.add(obj);
  }

  /// Remove game object from scene.
  void remove(GameObject obj) {
    _objects.remove(obj);
  }

  List<GameObject> get objects => _objects;

  String get uuid => _uuid;

  CameraManager get cameraManager => _cameraManager;
}
