import 'dart:html';
import 'dart:web_gl' as webGL;
import 'dart:async';

import 'texture.dart';
import './../loader/loader_manager.dart';

class TextureManager {
  /// WebGL Rendering context.
  static webGL.RenderingContext gl;

  static LoaderManager _loaderManager;

  /// List of WebGL textures.
  Map<String, Texture> _textures;

  TextureManager(LoaderManager loaderManager) {
    _loaderManager = loaderManager;
  }

  /// Create texture.
  Future<Texture> createTexture(String path) async {
    return new Texture(path, await _loaderManager.load(path));
  }
}