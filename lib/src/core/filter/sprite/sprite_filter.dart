part of ose;

class SpriteFilter extends Filter {
  SpriteFilter() : super(spriteShaderProgram) {
    attributes.addAll({
      'a_texCoord': new Attribute.FloatArray2()
    });
    uniforms.addAll({
      'u_model': new Uniform.Mat3(),
      'u_projection': new Uniform.Mat3(),
      'u_texture': new Uniform.Int1(0)
    });
  }

  void apply(SceneObject obj, Scene scene, Camera camera) {
    if (obj is Sprite) {
      attributes['a_texCoord'].update(obj.glTextureCoords);
      uniforms['u_texture'].update(0);
    }
    super.apply(obj, scene, camera);
  }
}
