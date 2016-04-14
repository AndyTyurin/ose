import './material.dart';
import './../texture/texture.dart';
import './../shader/shader.dart';

class BasicMaterial extends Material {

  /// Shader program manager.
  static ShaderProgramManager shaderProgramManager;

  /// Texture to use.
  Texture _texture;

  BasicMaterial({Texture texture}) : super() {
    _texture = texture;
  }
}