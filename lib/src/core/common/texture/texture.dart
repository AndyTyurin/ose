part of ose;

class Texture {
  String _uuid;

  ImageElement _image;

  Texture(this._image) : _uuid = utils.generateUuid();

  ImageElement get image => _image;
}
