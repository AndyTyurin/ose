part of ose;

/// Manages textures.
class TextureManager {
  /// WebGL rendering context.
  webGL.RenderingContext _gl;

  /// Currently bound texture.
  Texture _boundTexture;

  TextureManager(this._gl);

  /// Prepare texture.
  prepareTexture(OriginalTexture texture) {
    webGL.Texture glTexture = _gl.createTexture();
    texture.glTexture = glTexture;
    _gl.bindTexture(webGL.TEXTURE_2D, glTexture);
    _gl.pixelStorei(webGL.UNPACK_FLIP_Y_WEBGL, 1);
    _gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, texture.image);
    _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.LINEAR);
    _gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.LINEAR);
    _gl.generateMipmap(webGL.TEXTURE_2D);
    _gl.bindTexture(webGL.TEXTURE_2D, null);
  }

  /// Bind texture.
  bindTexture(Texture texture) {
    if (_boundTexture != texture) {
      _gl.activeTexture(webGL.TEXTURE0);
      _gl.bindTexture(webGL.TEXTURE_2D, texture.glTexture);
      _boundTexture = texture;
    }
  }

  /// Unbind texture.
  unbindTexture() {
    if (_boundTexture != null) {
      _gl.bindTexture(webGL.TEXTURE_2D, null);
      _boundTexture = null;
    }
  }
}
