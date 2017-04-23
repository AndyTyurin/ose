part of ose;

/// Register game resourses.
class AssetManager {
  /// Invokes on [registerTexture] and used by [Renderer] itself to proxy
  /// registration to [TextureManager].
  Function _onTextureRegister;

  /// Registered textures.
  Map<String, Texture> textures;

  AssetManager({void onTextureRegister(TextureRegisterEvent e)})
      : textures = <String, Texture>{} {
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
