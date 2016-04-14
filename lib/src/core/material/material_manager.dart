import 'dart:web_gl' as webGL;

import './material.dart';
import './basic_material.dart';
import './../texture/texture.dart';
import './../shader/shader.dart';

class MaterialManager {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Shader program manager.
  ShaderProgramManager _shaderProgramManager;

  /// List with unique materials.
  ///
  /// Each material has his own unique name.
  /// Use #create method to safely create a new one.
  Map<String, Material> _materials;

  MaterialManager(this._shaderProgramManager) {
    _materials = <String, Material>{};
    _propagateShaderProgramManager();
  }

  /// Create a new basic material.
  BasicMaterial createBasicMaterial(String name, {Texture texture}) {
    return registerMaterial(name, new BasicMaterial(texture: texture));
  }

  /// Register material in manager.
  Material registerMaterial(String name, Material material) {
    return _materials[name] = material;
  }

  /// Propagate shader program manager.
  ///
  /// Propagate shader program manager to different materials that are use it.
  void _propagateShaderProgramManager() {
    BasicMaterial.shaderProgramManager = _shaderProgramManager;
  }
}
