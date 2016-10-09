part of ose;

abstract class Filter {
  final ShaderProgram shaderProgram;

  final Map<String, Attribute> attributes;

  final Map<String, Uniform> uniforms;

  Filter(this.shaderProgram)
      : attributes = <String, Attribute>{
          'a_position': new Attribute.FloatArray2().._location = 0,
        },
        uniforms = <String, Uniform>{};

  void apply(SceneObject obj, Scene scene, Camera camera) {
    if ((obj as dynamic).glVertices != null) {
      attributes['a_position'].update((obj as dynamic).glVertices);
    }

    uniforms['u_model'].update(obj.transform.modelMatrix);
    uniforms['u_projection'].update(camera.transform.projectionMatrix);
  }
}
