library ose.core.shader;
import 'dart:web_gl' as webGL;
import 'dart:async';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

import './../loader/loader_manager.dart';

part './attribute.dart';
part './uniform.dart';
part 'shader_manager.dart';
part 'shader_program.dart';
part 'shader_program_manager.dart';

class Shader {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// WebGL shader.
  webGL.Shader _shader;

  /// Shader source.
  String _source;

  /// Path to shader file.
  String _path;

  /// Shader type.
  ///
  /// [webGL.VERTEX_SHADER] or [webGL.FRAGMENT_SHADER].
  int _type;

  /// Create new shader.
  ///
  /// [_path] is path to the shader.
  /// [_type] is [webGL.VERTEX_SHADER] or [webGL.FRAGMENT_SHADER].
  /// [_source] is shader source.
  Shader(this._path, this._type, this._source) {
    // Checks is shader source is not empty.
    if (_isShaderLoaded(_source, _type, _path)) {
      _shader = gl.createShader(_type);
      gl.shaderSource(_shader, _source);
      gl.compileShader(_shader);

      // Checks shader compile status.
      if (!gl.getShaderParameter(_shader, webGL.COMPILE_STATUS)) {
        throw new Exception("Couldn't compile"
            " ${ _getShaderNameByType(_type) } shader on path ${ _path }");
      }
    }
  }

  /// Get shader name.
  ///
  /// [type] can be [webGL.VERTEX_SHADER] or [webGL.FRAGMENT_SHADER].
  /// Commonly used to fetch name of the shader by type (Vertex or Fragment).
  static String _getShaderNameByType(int type) {
    return (type == webGL.VERTEX_SHADER) ? 'Vertex' : 'Fragment';
  }

  /// Checks is shader loaded.
  ///
  /// [source] is shader source.
  /// [type] is type of a shader, [VERTEX_SHADER] or [FRAGMENT_SHADER].
  /// [path] is url to shader file. Note that it is followed by CORS.
  /// Throw [Exception] if shader source is an empty.
  static bool _isShaderLoaded(String source, int type, String path) {
    if (source.isEmpty) {
      throw new Exception("${ _getShaderNameByType(type) }"
          " shader on path '${ path }' couldn't be loaded");
    }

    return true;
  }

  webGL.Shader get shader => _shader;

  String get source => _source;

  String get path => _path;

  int get type => _type;
}
