part of ose;

class SpriteFilter extends Filter {
  Light _activeLight;

  SpriteFilter() : super(spriteShaderProgram) {
    attributes.addAll({'a_texCoord': new Attribute.FloatArray2()});
    uniforms.addAll({
      'u_colorMap': new Uniform.Int1(0),
      'u_lightDirection': new Uniform.Float2(.0, .0),
      'u_lightColor': new Uniform.Float4(1.0, 1.0, 1.0, 1.0),
      'u_useDirectionalLight': new Uniform.Bool1(false)
    });
  }

  /// See [Filter.apply].
  void apply(
      FilterManager filterManager, Sprite obj, Scene scene, Camera camera) {
    bool useDirectionalLight = false;
    Vector2 lightDirection = null;
    SolidColor lightColor = null;
    if (_activeLight != null) {
      if (_activeLight is DirectionalLight) {
        useDirectionalLight = true;
        lightDirection = (_activeLight as DirectionalLight).direction;
      }
      filterManager.updateUniforms({
        'u_lightDirection': lightDirection,
        'u_lightColor': lightColor,
        'u_useDirectionalLight': useDirectionalLight
      });
    }
    filterManager.updateAttributes({'a_texCoord': obj.glTextureCoords});
    super.apply(filterManager, obj, scene, camera);
  }

  void setActiveLight(Light light) {
    _activeLight = light;
  }
}
