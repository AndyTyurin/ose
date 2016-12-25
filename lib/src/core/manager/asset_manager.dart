part of ose;

/// Register game resourses.
class AssetManager {
  /// Stream controller for [onTextureRegister] stream.
  StreamController<TextureRegisterEvent> _onTextureRegisterCtrl;

  /// Stream controller for [onTexturesRegister] stream.
  StreamController<TexturesRegisterEvent> _onTexturesRegisterCtrl;

  /// Stream controller for [onFilterRegister] stream.
  StreamController<FilterRegisterEvent> _onFilterRegisterCtrl;

  /// Stream controller for [onFiltersRegister] stream.
  StreamController<FiltersRegisterEvent> _onFiltersRegisterCtrl;

  /// Invokes on [registerFilter] and used by [Renderer] itself to proxy
  /// registration to [FilterManager].
  Function _onFilterRegister;

  /// Invokes on [registerTexture] and used by [Renderer] itself to proxy
  /// registration to [TextureManager].
  Function _onTextureRegister;

  /// Registered textures.
  Map<String, Texture> textures;

  /// Registered filters.
  Map<String, Filter> filters;

  /// Textures to register.
  Map<String, Texture> _texturesToRegister;

  /// Filters to register.
  Map<String, Filter> _filtersToRegister;

  AssetManager(
      {void onFilterRegister(FilterRegisterEvent e),
      void onTextureRegister(TextureRegisterEvent e)})
      : textures = <String, Texture>{},
        filters = <String, Filter>{} {
    _onFilterRegister = onFilterRegister;
    _onTextureRegister = onTextureRegister;
    _onTextureRegisterCtrl = new StreamController<TextureRegisterEvent>();
    _onFilterRegisterCtrl = new StreamController<FilterRegisterEvent>();
    _onTexturesRegisterCtrl = new StreamController<TexturesRegisterEvent>();
    _onFiltersRegisterCtrl = new StreamController<FiltersRegisterEvent>();
    _filtersToRegister = <String, Filter>{};
    _texturesToRegister = <String, Texture>{};
  }

  /// Register texture.
  /// Produce [TextureRegisterEvent] when texture will be registered.
  Future registerTexture(String name, Texture texture) async {
    if (textures.containsKey(name)) {
      window.console.warn("Texture with name \"${name}\" already registered.");
      return;
    }
    _texturesToRegister[name] = texture;
    TextureRegisterEvent event = new TextureRegisterEvent(name, texture);
    _onTextureRegister(event);
    _texturesToRegister.remove(name);
    textures[name] = texture;
    await _onTextureRegisterCtrl
      ..add(event)
      ..done;
  }

  /// Register multiply textures.
  /// Produce [TexturesRegisterEvent] when all textures will be registered.
  Future registerTextures(Map<String, Texture> textures) async {
    _texturesToRegister.addAll(textures);
    textures.forEach(await registerTexture);
    if (_texturesToRegister.length == 0)
      await _onTexturesRegisterCtrl
        ..add(new TexturesRegisterEvent(textures))
        ..done;
  }

  /// Register filter.
  /// Produce [FilterRegisterEvent] when filter will be registered.
  Future registerFilter(String name, Filter filter) async {
    if (filters.containsKey(name)) {
      window.console.warn("Filter with name \"${name}\" already registered.");
      return;
    }
    _filtersToRegister[name] = filter;
    FilterRegisterEvent event = new FilterRegisterEvent(name, filter);
    _onFilterRegister(event);
    _filtersToRegister.remove(name);
    filters[name] = filter;
    await _onFilterRegisterCtrl
      ..add(new FilterRegisterEvent(name, filter))
      ..done;
  }

  /// Register multply filters.
  /// Produce [FiltersRegisterEvent] when all filters will be registered.
  Future registerFilters(Map<String, Filter> filters) async {
    _filtersToRegister.addAll(filters);
    filters.forEach(await registerFilter);
    if (_filtersToRegister.length == 0) {
      await _onFiltersRegisterCtrl
        ..add(new FiltersRegisterEvent(filters))
        ..done;
    }
  }

  Stream<TextureRegisterEvent> get onTextureRegister =>
      _onTextureRegisterCtrl.stream;

  Stream<FilterRegisterEvent> get onFilterRegister =>
      _onFilterRegisterCtrl.stream;

  Stream<TexturesRegisterEvent> get onTexturesRegister =>
      _onTexturesRegisterCtrl.stream;

  Stream<FiltersRegisterEvent> get onFiltersRegister =>
      _onFiltersRegisterCtrl.stream;
}

/// Texture register event.
/// Will be raised when texture will be registered.
class TextureRegisterEvent {
  /// Registered texture.
  Texture texture;

  /// Name of registered texture.
  String name;

  TextureRegisterEvent(this.name, this.texture);
}

/// Filters register event.
/// Will be raised when filter will be registered.
class FilterRegisterEvent {
  /// Registered filter.
  Filter filter;

  /// Name of registered filter.
  String name;

  FilterRegisterEvent(this.name, this.filter);
}

/// Textures register event.
/// Will be reaised when all textures will be registered.
class TexturesRegisterEvent {
  /// All registered textures.
  Map<String, Texture> textures;

  TexturesRegisterEvent(this.textures);
}

/// Filter register event.
/// Will be reaised when all filters will be registered.
class FiltersRegisterEvent {
  /// All registered filters.
  Map<String, Filter> filters;

  FiltersRegisterEvent(this.filters);
}
