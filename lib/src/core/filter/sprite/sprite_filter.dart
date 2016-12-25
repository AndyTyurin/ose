part of ose;

/// tbd @andytyurin refactor it.
class SpriteFilter extends Filter {
  SpriteFilter() : super(spriteShaderProgram) {
    attributes.addAll({'a_texCoord': new Attribute.FloatArray2()});
    uniforms.addAll({
      'u_colorMap': new Uniform.Int1(0)
    });
  }

  /// See [Filter.apply].
  void apply(
      FilterManager filterManager, Sprite obj, Scene scene, Camera camera) {
    filterManager.updateAttributes({'a_texCoord': obj.glTextureCoords});
    super.apply(filterManager, obj, scene, camera);
  }
}
