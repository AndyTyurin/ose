part of ose;

/// Filter manager initialize, register & handle filters.
class FilterManager {
  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  /// List of registered filters.
  List<Filter> _filters;

  /// Default filters must be initialized to work with predefined objects.
  List<Filter> _defaultFilters;

  /// Currently active filter.
  Filter _activeFilter;

  /// Attribute manager handles attributes.
  AttributeManager _attributeManager;

  /// Uniform manager handles uniforms.
  UniformManager _uniformManager;

  /// Basic filter that is commonly used for objects like primitives.
  BasicFilter _basicFilter;

  /// Sprite filter that is commonly used for sprite objects.
  SpriteFilter _spriteFilter;

  /// Bound shader program.
  ShaderProgram _boundShaderProgram;

  FilterManager(this._gl) {
    _basicFilter = new BasicFilter();
    _spriteFilter = new SpriteFilter();
    _defaultFilters = <Filter>[_basicFilter, _spriteFilter];
    _filters = <Filter>[];
    _attributeManager = new AttributeManager(this._gl);
    _uniformManager = new UniformManager(this._gl);
  }

  void initDefaultFilters() {
    _defaultFilters.forEach(prepareFilter);
  }

  /// Update attributes values.
  void updateAttributes(Map<String, dynamic> values) {
    values.forEach((name, value) {
      _activeFilter.attributes[name].update(value);
    });
  }

  /// Update uniforms values.
  void updateUniforms(Map<String, dynamic> values) {
    values.forEach((name, value) {
      _activeFilter.uniforms[name].update(value);
    });
  }

  /// Bind active filter.
  /// See [activeFilter].
  void bindFilter() {
    if (_activeFilter.shaderProgram != _boundShaderProgram) {
      _boundShaderProgram = _activeFilter.shaderProgram;
      _gl.useProgram(_boundShaderProgram.glProgram);
    }
    _attributeManager.bindAttributes(_boundShaderProgram);
    _uniformManager.bindUniforms(_boundShaderProgram);
  }

  /// Prepare filter.
  void prepareFilter(Filter filter) {
    _prepareShaderProgram(filter.shaderProgram);
  }

  /// Prepare shader program.
  void _prepareShaderProgram(ShaderProgram shaderProgram) {
    // Create gl program if it hasn't been created before.
    if (shaderProgram.glProgram == null) {
      webGL.Program glProgram = _gl.createProgram();
      shaderProgram.glProgram = glProgram;

      Shader vertexShader = shaderProgram.vertexShader;
      Shader fragmentShader = shaderProgram.fragmentShader;

      _prepareShader(vertexShader);
      _prepareShader(fragmentShader);

      _gl.attachShader(glProgram, vertexShader.glShader);
      _gl.attachShader(glProgram, fragmentShader.glShader);

      _attributeManager.prepareAttributes(shaderProgram);

      _gl.linkProgram(glProgram);

      _attributeManager.generateLocations(shaderProgram);

      if (!_gl.getProgramParameter(glProgram, webGL.LINK_STATUS)) {
        throw new Exception("Can't compile program");
      }
    }
  }

  /// Prepare shader.
  void _prepareShader(Shader shader) {
    int glShaderType = (shader.type == ShaderType.Vertex)
        ? webGL.VERTEX_SHADER
        : webGL.FRAGMENT_SHADER;
    shader.glShader = _gl.createShader(glShaderType);
    webGL.Shader glShader = shader.glShader;
    _gl.shaderSource(glShader, shader.source);
    _gl.compileShader(glShader);

    // Checks shader compile status.
    if (!_gl.getShaderParameter(glShader, webGL.COMPILE_STATUS)) {
      throw new Exception("Can't compile shader ${shader.type}");
    }
  }

  List<Filter> get filters => _filters;

  void set filters(List<Filter> filters) {
    _filters = filters;
  }

  Filter get activeFilter => _activeFilter;

  void set activeFilter(Filter filter) {
    if (_filters.contains(filter) || _defaultFilters.contains(filter)) {
      _activeFilter = filter;
    } else {
      window.console.warn('Filter has not been registered');
    }
  }

  BasicFilter get basicFilter => _basicFilter;

  SpriteFilter get spriteFilter => _spriteFilter;

  List<Filter> get defaultFitlers => _defaultFilters;
}
