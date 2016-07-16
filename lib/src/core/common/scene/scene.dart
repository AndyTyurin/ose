part of ose;

abstract class Scene<T extends GameObject> {
  /// Unique id.
  String _uuid;

  /// List with gameobjects.
  ///
  /// Used by renderer to show off to the screen.
  List<T> _children;

  Scene()
      : this._uuid = utils.generateUuid(),
        this._children = <T>[];

  String get uuid => this._uuid;

  List<T> get children => this._children;
}
