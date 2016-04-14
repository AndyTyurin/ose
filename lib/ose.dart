library ose;

import 'dart:html';
import 'dart:web_gl' as webGL;

import './src/core/core.dart';

export './src/core/core.dart';
export './src/math/math.dart';

class Ose {
  /// WebGL renderer.
  WebGLRenderer _renderer;

  /// Material manager.
  ///
  /// Gives controls of different materials.
  /// By default it already has basic material, that is used in every created
  /// object. Further, new materials can be created and are kept there.
  MaterialManager _materialManager;

  /// Texture manager.
  ///
  /// Used to keep textures with unique path name for each of them.
  /// Main role is avoiding to load textures that already loaded, but
  /// they also can be re-written if it needed.
  TextureManager _textureManager;

  /// Shader manager.
  ///
  /// Keeps different vertex & fragment shaders with unique path.
  ShaderManager _shaderManager;

  /// Shader program manager.
  ///
  /// Manages different shader programs.
  /// Only one of them can be an active.
  ShaderProgramManager _shaderProgramManager;

  /// Loader manager.
  ///
  /// Primary usage is facade for fetching files from server.
  /// Files can be everything in text mime-type re-presentation, from
  /// shader files to different textures & sprites.
  LoaderManager _loaderManager;

  Ose({canvas: CanvasElement, width: int, height: int}) {
    _renderer = new WebGLRenderer(canvas: canvas, width: width, height: height);
    _renderer.onStart.listen((_) {
      window.console.log('pre-setup renderer');
    });
    _propagateRenderingContext();
    _createManagers();
  }

  /// Propagate WebGL rendering context.
  ///
  /// Propagates rendering context to all classes that are use it.
  void _propagateRenderingContext() {
    webGL.RenderingContext gl = _renderer.gl;
    Shader.gl = gl;
    ShaderManager.gl = gl;
    ShaderProgramManager.gl = gl;
    Texture.gl = gl;
    TextureManager.gl = gl;
    MaterialManager.gl = gl;
  }

  void _createManagers() {
    _shaderManager = new ShaderManager(_loaderManager);
    _shaderProgramManager = new ShaderProgramManager(_shaderManager);
    _loaderManager = new LoaderManager();

    _materialManager = new MaterialManager(_shaderProgramManager);
    _textureManager = new TextureManager(_loaderManager);
  }

  WebGLRenderer get renderer => _renderer;

  LoaderManager get loaderManager => _loaderManager;

  ShaderManager get shaderManager => _shaderManager;

  ShaderProgramManager get shaderProgramManager => _shaderProgramManager;

  TextureManager get textureManager => _textureManager;

  MaterialManager get materialManager => _materialManager;
}
