import 'dart:html';
import 'dart:web_gl' as webGL;
import 'dart:typed_data';

import 'package:ose/src/utils/utils.dart';

class Texture {
  /// WebGL rendering context.
  static webGL.RenderingContext gl;

  /// Square texture coordinates. todo: move to object
  static Float32List textureCoords = [1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0];

  /// Unique id.
  String _uuid;

  /// Image of a texture.
  ImageElement _image;

  /// WebGL texture.
  webGL.Texture _texture;

  /// Image path.
  String _path;

  /// Create a new texture.
  ///
  /// Note: use [TextureManager] to create new instance of Texture,
  /// don't use instance creation directly.
  Texture(this._path, this._image) {
    _uuid = generateUuid();
    _texture = gl.createTexture();
    bind();
    gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, _image);

    // Set parameters.
    gl.texParameteri(
        webGL.TEXTURE_2D, webGL.TEXTURE_WRAP_S, webGL.CLAMP_TO_EDGE);
    gl.texParameteri(
        webGL.TEXTURE_2D, webGL.TEXTURE_WRAP_T, webGL.CLAMP_TO_EDGE);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.LINEAR);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER,
        webGL.LINEAR_MIPMAP_NEAREST);

    // Checks if the image is power of 2.
    if (isPowerOfTwo(_image)) {
      gl.generateMipmap(webGL.TEXTURE_2D);
    } else {
      window.console.warn("Texture \"${ _image.src }\" dimensions "
          "is not preferred to power of two!");
    }

    unbind();
  }

  void bind() {
    gl.bindTexture(webGL.TEXTURE_2D, _texture);
  }

  void unbind() {
    gl.bindTexture(webGL.TEXTURE_2D, null);
  }

  String get uuid => _uuid;

  int get width => _image?.width;

  int get height => _image?.height;

  String get path => _path;

  ImageElement get image => _image;

  webGL.Texture get texture => _texture;
}
