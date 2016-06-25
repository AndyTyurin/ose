part of ose;

class BasicFilter extends Filter {
  /// Colors attribute.
  Attribute _aColor;

  /// Create new basic filter.
  BasicFilter() : super(ShaderProgramManager.programs[ShaderPrograms.Basic]) {
    _aColor = new Attribute.FloatArray4();
    this.addAttributes({'a_color': _aColor});
  }

  void apply(Scene scene, GameObject obj) {
    _aColor.update((obj as ColorsMixin).colors);
    super.apply(scene, obj);
  }

  Attribute get aColor => _aColor;
}
