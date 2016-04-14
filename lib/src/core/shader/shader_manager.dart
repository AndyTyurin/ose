part of ose.core.shader;

class ShaderManager {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Loader manager.
  static LoaderManager _loaderManager;

  /// List of shaders.
  ///
  /// Use [create] to define new shader in list.
  /// Note: each shader has his own unique path name (url to file).
  Map<String, Shader> _shaders;

  /// Create shader manager.
  ///
  /// [loaderManager] used to fetch shader by path.
  ShaderManager(LoaderManager loaderManager) {
    _loaderManager = loaderManager;
  }

  /// Create a new shader.
  ///
  /// [path] is path to the shader file.
  /// [type] is [webGL.VERTEX_SHADER] or [webGL.FRAGMENT_SHADER].
  Future<Shader> create(String path, int type) async {
    return _shaders[path] = new Shader(path, type, await _loaderManager.load(path));
  }

  Map<String, Shader> get shaders => _shaders;
}
