part of ose;

abstract class Filter {
  final ShaderProgram shaderProgram;

  Filter(this.shaderProgram);

  void apply(SceneObject obj, Scene scene, Camera camera) {
    if ((obj as dynamic).glVertices != null) {
      shaderProgram.attributes['a_position']
          .update((obj as dynamic).glVertices);
    }

    shaderProgram.uniforms['u_model'].update(obj.transform.modelMatrix);
    shaderProgram.uniforms['u_projection']
        .update(camera.transform.projectionMatrix);

    ShaderProgramManager.getInstance().bindProgram(shaderProgram);
  }
}
