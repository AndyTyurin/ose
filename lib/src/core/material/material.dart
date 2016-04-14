import 'dart:web_gl' as webGL;

import './../shader/shader.dart';

abstract class Material {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Shader program manager.
  static ShaderProgramManager shaderProgramManager;

  /// Create new material
  Material(this._shaderProgram);

  ShaderProgram _shaderProgram;

  ShaderProgram get program => _shaderProgram;
}