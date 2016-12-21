part of ose;

/// tbd @andytyurin refactor it.
abstract class ParticlesFilter extends Filter {
  ParticlesFilter() : super(particlesShaderProgram);

  /// See [Filter.apply].
  void apply(SceneObject obj, Scene scene, Camera camera) {
    super.apply(obj, scene, camera);
  }
}
