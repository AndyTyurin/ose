part of ose;

class Sprite extends SceneObject {
  static String shaderProgramName = utils.generateUuid();

  /// Color map texture to use.
  Texture _texture;

  /// Normal map texture to use.
  Texture _normalMapTexture;

  /// WebGL texture bounds.
  Vector4 _glTextureBounds;

  /// WebGL texture coordinates.
  Float32List _glTextureCoords;

  Sprite()
      : super(new Float32List.fromList(
            [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0])) {
    _glTextureCoords =
        new Float32List.fromList([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]);
  }

  static String getVertexShaderSource(int maxLights) {
    return ""
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
  }

  static String getFragmentShaderSource(int maxLights) {
    return ""
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
  }

  void _rebuildCoordinates() {
    ImageElement textureImg = _texture.image;
    int textureWidth = textureImg.width;
    int textureHeight = textureImg.height;
    double aspectRatio = min(1.0 / textureWidth, 1.0 / textureHeight);
    double unitTextureWidth = textureWidth * aspectRatio;
    double unitTextureHeight = textureHeight * aspectRatio;
    double ratioX = 1.0 / unitTextureWidth;
    double ratioY = 1.0 / unitTextureHeight;
    double spriteSizeX = (glTextureBounds.z - glTextureBounds.x) / ratioX;
    double spriteSizeY =
        ((1.0 - glTextureBounds.y) - (1.0 - glTextureBounds.w)) / ratioY;
    double indentX = .5 - spriteSizeX / 2;
    double indentY = .5 - spriteSizeY / 2;

    _glVertices = new Float32List.fromList([
      indentX,
      indentY,
      indentX,
      indentY + spriteSizeY,
      indentX + spriteSizeX,
      indentY,
      indentX + spriteSizeX,
      indentY + spriteSizeY
    ]);

    _glTextureCoords = new Float32List.fromList([
      _glTextureBounds.x,
      _glTextureBounds.y,
      _glTextureBounds.x,
      _glTextureBounds.w,
      _glTextureBounds.z,
      _glTextureBounds.y,
      _glTextureBounds.z,
      _glTextureBounds.w
    ]);
  }

  void _setOriginalTexture(OriginalTexture texture) {
    _texture = texture;
    _glTextureBounds = new Vector4(0.0, 0.0, 1.0, 1.0);
    _rebuildCoordinates();
  }

  void _setSubTexture(SubTexture texture) {
    OriginalTexture originalTexture = texture.originalTexture;
    ImageElement textureImg = originalTexture.image;
    int width = textureImg.width;
    int height = textureImg.height;
    Vector4 boundingVector = texture.boundingRect.toVector4();
    _glTextureBounds = boundingVector
      ..setValues(boundingVector.x / width, 1 - boundingVector.w / height,
          boundingVector.z / width, 1 - boundingVector.y / height);
    _texture = texture;
    _rebuildCoordinates();
  }

  @override
  void copyFrom(Sprite from) {
    super.copyFrom(from);
    _texture = from.texture;
  }

  Texture get texture => _texture;

  Texture get colorMap => _texture;

  void set texture(Texture texture) {
    if (texture is OriginalTexture) {
      _setOriginalTexture(texture);
    } else if (texture is SubTexture) {
      _setSubTexture(texture);
    }
  }

  void set colorMap(Texture texture) {
    this.texture = texture;
  }

  Texture get normalMap => _normalMapTexture;

  void set normalMap(Texture texture) {
    _normalMapTexture = texture;
  }

  webGL.Texture get glTexture => _texture.glTexture;

  webGL.Texture get glNormalMap => _normalMapTexture.glTexture;

  Vector4 get glTextureBounds => _glTextureBounds;

  Float32List get glTextureCoords => _glTextureCoords;

  bool get hasTexture => _texture != null;

  @override
  String getShaderProgramName() {
    return shaderProgramName;
  }
}
