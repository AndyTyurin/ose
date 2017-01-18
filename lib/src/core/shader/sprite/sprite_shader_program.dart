part of ose;

ShaderProgram createSpriteShaderProgram(int maxLights) {
  return new ShaderProgram(
      new Shader(ShaderType.Vertex, _genVertexSpriteSrc(maxLights)),
      new Shader(ShaderType.Fragment, _genFragmentSpriteSrc(maxLights)));
}
