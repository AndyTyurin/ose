part of ose;

class Scene<SceneObject> {
  /// Unique id.
  String _uuid;

  /// List with gameobjects.
  ///
  /// Used by renderer to show off to the screen.
  List<SceneObject> _children;

  Scene()
      : _uuid = utils.generateUuid(),
        _children = <SceneObject>[];

  String get uuid => _uuid;

  List<SceneObject> get children => _children;
}
