part of ose;

/// Manages textures.
class TextureManager {
  static final Map<TextureType, int> typeToLocationMap = <TextureType, int>{
    TextureType.Color: webGL.TEXTURE0,
    TextureType.Normal: webGL.TEXTURE1
  };

  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  /// Currently bound color map texture.
  Texture _boundColorMapTexture;

  /// Currently bound normal map texture.
  Texture _boundNormalMapTexture;

  TextureManager(this._gl);

  /// Prepare texture.
  prepareTexture(OriginalTexture texture) {
    webGL.Texture glTexture = _gl.createTexture();
    texture.glTexture = glTexture;
    _gl.bindTexture(webGL.TEXTURE_2D, glTexture);
    _gl.pixelStorei(webGL.UNPACK_FLIP_Y_WEBGL, 1);
    _gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, texture.image);
    _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.NEAREST);
    _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.NEAREST);
    _gl.generateMipmap(webGL.TEXTURE_2D);
    _gl.bindTexture(webGL.TEXTURE_2D, null);
  }

  /// Bind texture.
  bindTexture(Texture texture, [TextureType textureType = TextureType.Color]) {
    if (textureType == TextureType.Color && _boundColorMapTexture != texture) {
      _bindParticularTexture(texture, typeToLocationMap[TextureType.Color]);
    } else if (textureType == TextureType.Normal && _boundNormalMapTexture != texture) {
      _bindParticularTexture(texture, typeToLocationMap[TextureType.Normal]);
    }
  }

  /// Unbind bound texture.
  unbindTexture([TextureType textureType = TextureType.Color]) {
    if (textureType == TextureType.Color) {
      _gl.activeTexture(typeToLocationMap[TextureType.Color]);
      _gl.bindTexture(webGL.TEXTURE_2D, null);
      _boundColorMapTexture = null;
    } else if (textureType == TextureType.Normal) {
      _gl.activeTexture(typeToLocationMap[TextureType.Normal]);
      _gl.bindTexture(webGL.TEXTURE_2D, null);
      _boundNormalMapTexture = null;
    }
  }

  // Bind particular texture to specific texture location.
  _bindParticularTexture(Texture texture, int location) {
    _gl.activeTexture(location);
    _gl.bindTexture(webGL.TEXTURE_2D, texture.glTexture);
  }
}
