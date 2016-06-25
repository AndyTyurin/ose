library ose;

import 'dart:html';
import 'dart:typed_data';
import 'dart:async';
import 'dart:web_gl' as webGL;
import 'dart:math' as math;

import 'ose_math.dart';
import 'ose_utils.dart' as utils;

part 'src/core/camera/camera.dart';
part 'src/core/filter/filter-manager.dart';
part 'src/core/filter/filter.dart';
part 'src/core/filter/basic_filter.dart';
part 'src/core/loader/loader_manager.dart';
part 'src/core/object/game_object.dart';
part 'src/core/object/rectangle.dart';
part 'src/core/object/triangle.dart';
part 'src/core/object/circle.dart';
part 'src/core/object/mixins/colors-mixin.dart';
part 'src/core/object/mixins/filter-mixin.dart';
part 'src/core/object/mixins/texture-mixin.dart';
part 'src/core/object/mixins/vertices-mixin.dart';
part 'src/core/renderer/webgl_renderer.dart';
part 'src/core/scene/scene.dart';
part 'src/core/shader/attribute.dart';
part 'src/core/shader/uniform.dart';
part 'src/core/shader/shader_program.dart';
part 'src/core/shader/shader_manager.dart';
part 'src/core/shader/shader_program_manager.dart';
part 'src/core/shader/shader.dart';
part 'src/core/texture/texture.dart';
part 'src/core/texture/texture_manager.dart';
part 'src/core/transform/transform.dart';

class Ose {

  static const String projectPackage = 'packages/ose';

  /// WebGL renderer.
  WebGLRenderer _renderer;

  /// Loader manager.
  ///
  /// Primary usage is facade for fetching files from server.
  /// Files can be everything in text mime-type re-presentation, from
  /// shader files to different textures & sprites.
  LoaderManager _loaderManager;

  ShaderManager _shaderManager;

  ShaderProgramManager _shaderProgramManager;

  TextureManager _textureManager;

  /// Is renderer created & prepared.
  bool _isRendererPrepared = false;

  /// Create WebGL Renderer.
  ///
  /// It also initialize rendering context & managers.
  ///
  /// Note: it's async process and you must wait until renderer will be created.
  Future<WebGLRenderer> createWebGLRenderer(
      {canvas: CanvasElement, width: int, height: int}) async {
    _renderer = new WebGLRenderer(canvas: canvas, width: width, height: height);
    _propagateRenderingContext();
    _createManagers();
    await _initFilters();
    _isRendererPrepared = true;

    return _renderer;
  }

  /// Propagate WebGL rendering context.
  ///
  /// Propagates rendering context to all classes that are use it.
  void _propagateRenderingContext() {
    webGL.RenderingContext gl = _renderer.gl;
    Shader.gl = gl;
    ShaderProgram.gl = gl;
    ShaderProgramManager.gl = gl;
    Texture.gl = gl;
    Attribute.gl = gl;
  }

  /// Create managers.
  void _createManagers() {
    _shaderManager = new ShaderManager();

    _shaderProgramManager = new ShaderProgramManager();

    TextureManager.loaderManager = _loaderManager;
    _textureManager = new TextureManager();
  }

  Future _initFilters() async {

    // Basic shader program.
    BasicFilter.basicShaderProgram = await shaderProgramManager.create(
        "${projectPackage}/res/glsl/basic.v.glsl",
        "${projectPackage}/res/glsl/basic.f.glsl");
  }

  WebGLRenderer get renderer {
    if (!_isRendererPrepared) {
      throw new Exception('Renderer is not prepared, waits until'
          ' createWebGLRenderer to create and prepare renderer');
    }

    return _renderer;
  }

  LoaderManager get loaderManager => _loaderManager;

  ShaderProgramManager get shaderProgramManager => _shaderProgramManager;

  ShaderManager get shaderManager => _shaderManager;

  TextureManager get textureManager => _textureManager;
}