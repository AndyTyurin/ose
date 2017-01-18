part of ose;

class SpriteFilter extends Filter {
  final int maxLights;
  SpriteFilter({int maxLights: 4})
      : maxLights = maxLights,
        super(createSpriteShaderProgram(maxLights)) {
    attributes.addAll({'a_texCoord': new Attribute.FloatArray2()});
    uniforms.addAll({
      'u_colorMap': new Uniform.Int1(0),
      'u_normalMap': new Uniform.Int1(1),
      'u_ambientLightColor': new Uniform.Float4(),
      'u_lightDirection': new Uniform.FloatArray2(),
      'u_lightPosition': new Uniform.FloatArray2(),
      'u_lightColor': new Uniform.FloatArray4(),
      'u_lightFalloff': new Uniform.FloatArray3(),
      'u_lightType': new Uniform.IntArray1(),
      'u_useNormalMap': new Uniform.Bool1(false)
    });
  }

  /// See [Filter.apply].
  void apply(
      FilterManager filterManager, Sprite obj, Scene scene, Camera camera) {
    filterManager.updateAttributes({'a_texCoord': obj.glTextureCoords});

    AmbientLight ambientLight = scene.ambientLight;

    bool useDirectionalLight = false;
    bool usePointLight = false;

    if (_isLightningAvailable(obj, scene)) {
      List<int> lightTypes = <int>[];
      List<double> lightPositions = <double>[];
      List<double> lightColors = <double>[];
      List<double> lightFalloffs = <double>[];
      List<double> lightDirections = <double>[];

      for (int i = 0; i < maxLights; i++) {
        Light light =
            (scene.lights.length > i) ? scene.lights.elementAt(i) : null;
        int lightType = 0;
        Vector2 lightPosition = new Vector2.zero();
        SolidColor lightColor = new SolidColor.white();
        Vector3 lightFalloff = new Vector3.zero();
        Vector2 lightDirection = new Vector2.zero();
        if (light == null) break;
        if (light is DirectionalLight) {
          useDirectionalLight = true;
          lightType = 1;
          lightDirection = light.direction;
        } else if (light is PointLight) {
          usePointLight = true;
          lightPosition = light.position;
          lightFalloff = light.falloff;
          lightType = 2;
        }
        lightColor = light.color;
        lightTypes.add(lightType);
        lightColors.addAll(lightColor.toIdentity());
        lightDirections.addAll(lightDirection.storage);
        lightFalloffs.addAll(lightFalloff.storage);
        lightPositions.addAll(lightPosition.storage);
      }

      if (!useDirectionalLight) {
        _ignoreDirectionalLight(filterManager);
      }

      if (!usePointLight) {
        _ignorePointLight(filterManager);
      }

      filterManager.updateUniforms({
        'u_lightPosition': new Float32List.fromList(lightPositions),
        'u_lightColor': new Float32List.fromList(lightColors),
        'u_lightFalloff': new Float32List.fromList(lightFalloffs),
        'u_lightType': new Int8List.fromList(lightTypes),
        'u_lightDirection': new Float32List.fromList(lightDirections),
        'u_useNormalMap': true
      });
    } else {
      _ignoreComplexLightning(filterManager);
    }

    if (ambientLight == null) {
      filterManager.ignoreUniforms(['u_ambientLightColor']);
    } else {
      filterManager.updateUniforms({
        'u_ambientLightColor':
            ambientLight?.color ?? new SolidColor([0, 0, 0, 0])
      });
    }

    super.apply(filterManager, obj, scene, camera);
  }

  void _ignoreDirectionalLight(FilterManager filterManager) {
    filterManager.ignoreUniforms(['u_lightDirection']);
  }

  void _ignorePointLight(FilterManager filterManager) {
    filterManager.ignoreUniforms(['u_lightFalloff', 'u_lightPosition']);
  }

  void _ignoreComplexLightning(FilterManager filterManager) {
    _ignoreDirectionalLight(filterManager);
    _ignorePointLight(filterManager);
    filterManager.ignoreUniforms(['u_lightType', 'u_lightColor']);
  }

  bool _isLightningAvailable(Sprite obj, Scene scene) =>
      obj.normalMap != null && scene.lights.length > 0;
}
