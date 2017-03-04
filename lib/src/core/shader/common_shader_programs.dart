/// Common shader programs.
///
/// There are several already defined programs available:
/// * Sprite shader program for rendering sprite objects;
/// * Primitive shader program for rendering primitives.
///
/// Note, each shader will get a common header definitions with model, view,
/// projection matrix in shader program initialization.
///
/// See [shaderVertexHeaderDefinitions] and [shaderFragmentHeaderDefinitions]
/// to get more about available common header definitions.

part of ose;

/// Generate sprite shader programs by using of [context] and set max
/// available lights at the same time available on scene.
ShaderProgram generateSpriteShaderProgram(
    webGL.RenderingContext context, int maxLights) {
  String spriteVertexShaderSrc = ""
      // Texel position.
      "attribute vec2 a_texCoord;"
      // Lights positions (only for spot lights).
      "uniform vec2 u_lightPosition[${maxLights}];"
      // Lights directions (only for directional lights).
      "uniform vec2 u_lightDirection[${maxLights}];"
      // Lights types.
      // 0 - light not bound.
      // 1 - directional light.
      // 2 - spot light.
      "uniform int u_lightType[${maxLights}];"
      // Use normal map.
      "uniform bool u_useNormalMap;"
      // Lights rays (directiona vector & distance from light source to target
      // object). For directional lights it will be converted to direction vector.
      "varying vec2 v_lightRay[${maxLights}];"
      // Interpolated texel coordinates.
      "varying vec2 v_texCoord;"
      "void main() {"
      // Convert to projection-view-model space from -1 to 1.
      "vec2 pos = (u_m * vec3(a_position * 2.0 - 1.0, 1.0)).xy;"
      // Set texel position.
      "v_texCoord = a_texCoord;"
      "if (u_useNormalMap == true) {"
      // Iterate through the lights and set ray to each one if light has been bound.
      "for (int i = 0; i < ${maxLights}; i++) {"
      "if (u_lightType[i] == 0) {"
      "break;"
      "}"
      "vec2 lightRay;"
      "if (u_lightType[i] == 1) {"
      "lightRay = u_lightDirection[i];"
      "} else if (u_lightType[i] == 2) {"
      "lightRay = vec2(u_lightPosition[i].x - pos.x, pos.y - u_lightPosition[i].y);"
      "}"
      "v_lightRay[i].x = lightRay.x * u_m[0][0] + lightRay.y * u_m[1][0];"
      "v_lightRay[i].y = lightRay.x * u_m[1][0] - lightRay.y * u_m[0][0];"
      "}"
      "}"
      // Set vertex position.
      "gl_Position = vec4((u_p * u_v * vec3(pos, 1.0)).xy, 1.0, 1.0);"
      "}";

  String spriteFragmentShaderSrc = ""
      // Target's color map.
      "uniform sampler2D u_colorMap;"
      // Target's normal map.
      "uniform sampler2D u_normalMap;"
      // Ambient color.
      "uniform vec4 u_ambientLightColor;"
      // Lights colors.
      "uniform vec4 u_lightColor[${maxLights}];"
      // Lights falloffs (x + y * D + z * D * D, by default [0.75, 3, 20]).
      "uniform vec3 u_lightFalloff[${maxLights}];"
      // Lights types.
      // 0 - light not bound.
      // 1 - directional light.
      // 2 - spot light.
      "uniform int u_lightType[${maxLights}];"
      // Use normal map.
      "uniform bool u_useNormalMap;"
      // Lights rays (directiona vector & distance from light source to target
      // object). For directional lights it will be converted to direction vector.
      "varying vec2 v_lightRay[${maxLights}];"
      // Interpolated texels.
      "varying vec2 v_texCoord;"
      "void main() {"
      // Get color from color map texture.
      "vec4 color = texture2D(u_colorMap, v_texCoord);"
      // Final color will be accumulated by lightning.
      "vec3 finalColor = color.rgb;"
      "if (u_useNormalMap == true) {"
      // Get normal from normal map texture.
      "vec2 N = normalize(texture2D(u_normalMap, v_texCoord).xy * 2.0 - 1.0);"
      // Process each light.
      "for (int i = 0; i < ${maxLights}; i++) {"
      "if (u_lightType[i] == 0) {"
      "break;"
      "}"
      // Attenuation factor.
      "float attenuation = 1.0;"
      // Get light direction.
      "vec2 L = normalize(v_lightRay[i]);"
      // Calculate light diffuse.
      "vec3 lightDiffuse = (u_lightColor[i].rgb * u_lightColor[i].a) * max(dot(N, L), 0.0);"
      // Calculate attenuation for spot light.
      "if (u_lightType[i] == 2) {"
      "vec3 lightFalloff = u_lightFalloff[i];"
      "float D = length(v_lightRay[i]);"
      "attenuation = 1.0 / (lightFalloff.x + lightFalloff.y * D + lightFalloff.z * D * D);"
      "}"
      // Accumulate lightning.
      "finalColor += lightDiffuse * attenuation;"
      "}"
      "}"
      // Set color.
      "gl_FragColor = vec4(u_ambientLightColor.rgb * u_ambientLightColor.a + finalColor, color.a);"
      "}";

  return new ShaderProgram(
      context, spriteVertexShaderSrc, spriteFragmentShaderSrc);
}

/// Generate primitive shader program by using of [context].
ShaderProgram generatePrimitiveShaderProgram(webGL.RenderingContext context) {
  String primitiveVertexShaderSrc = ""
      "attribute vec4 a_color;"
      "varying vec4 v_color;"
      "void main() {"
      "vec2 pos = vec2(a_position.x, a_position.y) * 2.0 - 1.0;"
      "gl_Position = vec4((u_projection * u_view * u_model * vec3(pos, 1.0)).xy, 1.0, 1.0);"
      "v_color = a_color;"
      "}";

  String primitiveFragmentShaderSrc = "precision mediump float;"
      "varying vec4 v_color;"
      "void main() {"
      "gl_FragColor = v_color;"
      "}";
  return new ShaderProgram(
      context, primitiveVertexShaderSrc, primitiveFragmentShaderSrc);
}
