part of ose;

/// Interface define methods that returns data necessary to register
/// shader program.
abstract class ShaderDataProvider {
  /// Implement to define specific vertex shader to use.
  String getVertexShaderSource();

  /// Implement to define specific fragment shader to use.
  String getFragmentShaderSource();

  /// Implement to define specific uuid for your shader program that will be
  /// used while registering.
  String getShaderProgramId();

  /// Should use common shader definitions while registering in manager.
  /// If [true], Some attributes, uniforms and rules will be defined on
  /// top of your shaders' sources (vertex and fragment).
  bool shouldUseCommonShaderDefinitions() {
    return true;
  }
}
