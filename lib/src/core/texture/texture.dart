part of ose;

class Texture {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  static Texture _bondedTexture;

  /// Unique id.
  String _uuid;

  /// Image of a texture.
  ImageElement _image;

  /// WebGL texture.
  webGL.Texture _texture;

  /// Create a new texture.
  Texture(this._image) {
    _uuid = utils.generateUuid();

    // Check if the image is power of 2.
    if (utils.isPowerOfTwo(_image)) {
      gl.generateMipmap(webGL.TEXTURE_2D);
    } else {
      window.console.warn("Texture \"${ _image.src }\" dimensions "
          "is not preferred to power of two!");
    }

    // Create a new WebGL texture.
    _texture = gl.createTexture();

    // Bind texture.
    bind();

    // Flip texture.
    gl.pixelStorei(webGL.UNPACK_FLIP_Y_WEBGL, 1);

    gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, _image);

    // Set texture parameters.
    gl.texParameteri(
        webGL.TEXTURE_2D, webGL.TEXTURE_WRAP_S, webGL.CLAMP_TO_EDGE);
    gl.texParameteri(
        webGL.TEXTURE_2D, webGL.TEXTURE_WRAP_T, webGL.CLAMP_TO_EDGE);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER,
        webGL.LINEAR_MIPMAP_NEAREST);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.LINEAR);

    unbind();
  }

  /// Bind texture.
  ///
  /// Only one texture can be bonded to same location in time.
  void bind() {
    if (_bondedTexture != this) {
      gl.activeTexture(webGL.TEXTURE0);
      gl.bindTexture(webGL.TEXTURE_2D, _texture);
      _bondedTexture = this;
    }
  }

  /// Unbind texture.
  void unbind() {
    gl.bindTexture(webGL.TEXTURE_2D, null);
    _bondedTexture = null;
  }

  bool operator ==(Texture texture) {
    return _uuid == texture.uuid;
  }

  String get uuid => _uuid;

  int get width => _image?.width;

  int get height => _image?.height;

  ImageElement get image => _image;

  webGL.Texture get texture => _texture;
}
