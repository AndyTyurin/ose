part of ose;

class SpriteFilter extends Filter {
  SpriteFilter() : super(spriteShaderProgram);

  void apply(SceneObject obj, Scene scene, Camera camera) {
    if (obj is Sprite) {
      shaderProgram.attributes['a_texCoord'].update(obj.glTextureCoords);
      shaderProgram.uniforms['u_texture'].update(0);
      if (obj.glTextureBounds != null) {
        shaderProgram.uniforms['u_texBounds'].update(obj.glTextureBounds);
      }
    }
    super.apply(obj, scene, camera);
  }
}
