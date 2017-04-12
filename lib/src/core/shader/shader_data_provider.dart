part of ose;

/// Common interface to link instances to specific shader program.
abstract class ShaderDataProvider {
  /// Implement by returning specific name of the shader program to use.
  /// Note: shader program must be initialized before rendering.
  String getShaderProgramName();
}
