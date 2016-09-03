part of ose_webgl;

abstract class Filter {
  /// Shader program.
  final ShaderProgram shaderProgram;

  Filter(this.shaderProgram);

  /// See [ose.Filter.apply].
  void apply(ose.GameObject obj, ose.Scene scene, ose.Camera camera) {
    if ((obj as dynamic).glVertices != null) {
      shaderProgram.attributes['a_position'].update((obj as dynamic).glVertices);
    }

    shaderProgram.uniforms['u_model'].update(obj.transform.modelMatrix);
    shaderProgram.uniforms['u_projection']
        .update(camera.transform.projectionMatrix);

    ShaderProgramManager.getInstance().bindProgram(shaderProgram);
    shaderProgram.applyAttributes();
    shaderProgram.applyUniforms();
  }
}
