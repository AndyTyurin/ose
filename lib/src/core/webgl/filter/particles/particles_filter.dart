part of ose_webgl;

abstract class ParticlesFilter extends Filter {
  ParticlesFilter() : super(particlesShaderProgram);

  /// See [Filter.apply].
  void apply(ose.GameObject obj, ose.Scene scene, ose.Camera camera) {
    super.apply(obj, scene, camera);
  }
}
