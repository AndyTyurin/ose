part of ose;

class Scene<T extends GameObject> {
  /// Unique id.
  String _uuid;

  /// List with gameobjects.
  ///
  /// Used by renderer to show off to the screen.
  List<T> _children;

  Scene()
      : _uuid = utils.generateUuid(),
        _children = <T>[];

  String get uuid => _uuid;

  List<T> get children => _children;
}
