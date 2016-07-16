part of ose_webgl;

// TODO: Re-factor shader manager.
// TODO: Write loader manager.

/// Shader manager.
///
/// Creates a new shaders either to cache already exists.
class ShaderManager {
  /// Loader manager.
  LoaderManager _loaderManager;

  /// List with cached shaders.
  Map<String, Shader> _shaders = <String, Shader>{};

  ShaderManager() {
    _shaders = <String, Shader>{};
    _loaderManager = new LoaderManager();
  }

  /// Create a new shader.
  ///
  /// [shaderPath] is path to the shader file.
  /// [type] is [ShaderType.Vertex] or [ShaderType.Fragment].
  Future<Shader> create(String shaderPath, ShaderType type) async {
    if (_shaders[shaderPath] != null) {
      return (new Completer<Shader>()..complete(_shaders[shaderPath])).future;
    }

    return _shaders[shaderPath] =
        new Shader(type, await _loaderManager.load(shaderPath));
  }

  Map<String, Shader> get shaders => _shaders;

  Function get onLoad => _loaderManager.onLoad;

  Function get onProgress => _loaderManager.onProgress;

  Function get onError => _loaderManager.onError;

  set onLoad(Function onLoad) => _loaderManager.onLoad = onLoad;

  set onProgress(Function onProgress) => _loaderManager.onProgress = onProgress;

  set onError(Function onError) => _loaderManager.onError = onError;
}
