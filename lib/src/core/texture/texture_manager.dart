part of ose;

class TextureManager {
  /// Loader manager.
  LoaderManager _loaderManager;

  /// List of textures.
  Map<String, Texture> _textures;

  TextureManager() {
    _textures = <String, Texture>{};
    _loaderManager = new LoaderManager();
  }

  /// Load texture.
  ///
  /// Create new texture or return it from cache.
  Future<Texture> create(String imgPath) async {
    if (_textures[imgPath] != null) {
      return (new Completer<Texture>()..complete(_textures[imgPath])).future;
    }

    return _textures[imgPath] = new Texture(await _loaderManager.load(imgPath));
  }

  Function get onLoad => _loaderManager.onLoad;

  Function get onProgress => _loaderManager.onProgress;

  Function get onError => _loaderManager.onError;

  set onLoad(Function onLoad) => _loaderManager.onLoad = onLoad;

  set onProgress(Function onProgress) => _loaderManager.onProgress = onProgress;

  set onError(Function onError) => _loaderManager.onError = onError;
}