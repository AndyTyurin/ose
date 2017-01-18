part of ose;

/// Register game resourses.
class AssetManager {
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

  AssetManager(
      {void onFilterRegister(FilterRegisterEvent e),
      void onTextureRegister(TextureRegisterEvent e)})
      : textures = <String, Texture>{},
        filters = <String, Filter>{} {
    _onFilterRegister = onFilterRegister;
    _onTextureRegister = onTextureRegister;
  }

  /// Register texture.
  void registerTexture(String name, Texture texture) {
    if (textures.containsKey(name)) {
      window.console.warn("Texture with name \"${name}\" already registered.");
    } else {
      textures[name] = texture;
      if (_onTextureRegister != null) {
        _onTextureRegister(new TextureRegisterEvent(name, texture));
      }
    }
  }

  /// Register multiply textures.
  void registerTextures(Map<String, Texture> textures) {
    textures.forEach(registerTexture);
  }

  /// Register filter.
  Future registerFilter(String name, Filter filter) async {
    if (filters.containsKey(name)) {
      window.console.warn("Filter with name \"${name}\" already registered.");
    } else {
      filters[name] = filter;
      if (_onFilterRegister != null) {
        _onFilterRegister(new FilterRegisterEvent(name, filter));
      }
    }
  }

  /// Register multply filters.
  Future registerFilters(Map<String, Filter> filters) async {
    filters.forEach(registerFilter);
  }
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
