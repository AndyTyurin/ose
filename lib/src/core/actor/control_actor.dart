part of ose;

/// Control actor is derived from [Actor] and have same logic except
/// one distinction, additional parameter in method [update].
/// It gives opportunity to use input manager to check input controllers
/// states and handle object behavior.
///
/// For example.
/// You are a player and have your own spaceship (scene object).
/// You can create your own [PlayerActor] that will extends [ControlActor]
/// and implement [update] method, that checks keyboard arrow buttons and
/// set movement of your spaceship by calling methods of your [SceneObject].
///
/// Note, that you can create your own class that will extends
/// [SceneObject] with public API such as [moveForward], [moveLeft], [moveRight].
///
/// Best practice to use API of your specific [SceneObject] to make different
/// changes in state of your object.
///
/// See more in [Actor].
abstract class ControlActor extends Actor {
  @override
  void update(Scene scene, SceneObject sceneObject, [IOManager ioManager]);
}
