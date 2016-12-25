part of ose;

/// Resource loader can load and handle resources.
/// Use [onLoad], [onError], [onProgress] streams to handle events.
class ResourceLoader {
  /// Stream controller for [onLoad] stream.
  StreamController<ResourceLoadEvent> _onLoadCtrl;

  /// Stream controller for [onError] stream.
  StreamController<ResourceErrorEvent> _onErrorCtrl;

  /// Stream controller for [onProgress] stream.
  StreamController<ResourceProgressEvent> _onProgressCtrl;

  ResourceLoader() {
    _onLoadCtrl = new StreamController<ResourceLoadEvent>();
    _onErrorCtrl = new StreamController<ResourceErrorEvent>();
    _onProgressCtrl = new StreamController<ResourceProgressEvent>();
  }

  /// Load texture by [path].
  Future loadTexture(String path) async {
    ImageElement img = new ImageElement();
    HttpRequest
        .request(path,
            responseType: 'blob', onProgress: (e) => _onProgress(path, e))
        .then((HttpRequest res) {
      img.src = Url.createObjectUrl(res.response);
    }).catchError((e) => _onTextureError(path, e));

    return img.onLoad.first.then((_) => _onTextureLoad(path, img),
        onError: (String path, Error e) => _onTextureError(path, e));
  }

  /// Load shader source by [path].
  Future<Shader> loadShader(String path, ShaderType type) async {
    return HttpRequest
        .request(path, onProgress: (e) => _onProgress(path, e))
        .then((HttpRequest res) {
      return _onShaderLoad(path, res.response, type);
    }).catchError((e) => _onShaderError(path, e));
  }

  /// Handle image loading progress.
  /// Fires [onProgress].
  void _onProgress(String path, ProgressEvent e) {
    _onProgressCtrl.add(new ResourceProgressEvent(path, e.loaded, e.total, e.lengthComputable));
  }

  /// Load image & create [Texture].
  /// Fires [onLoad].
  Texture _onTextureLoad(String path, ImageElement img) {
    Texture texture = new Texture(img);
    _onLoadCtrl.add(new ResourceLoadEvent(path, texture));
    return texture;
  }

  /// Handle image loading error.
  /// Fires [onError].
  Exception _onTextureError(String path, Error e) {
    Exception notFoundError =
        new Exception('Image not found on path \"${path}\"');
    _onErrorCtrl.add(new ResourceErrorEvent(path, notFoundError));
    return new Exception(notFoundError);
  }

  /// Load shader source and create [Shader].
  Shader _onShaderLoad(String path, String source, ShaderType type) {
    Shader shader = new Shader(type, source);
    _onLoadCtrl.add(new ResourceLoadEvent(path, shader));
    return shader;
  }

  /// Handle shader loading error.
  /// Fires [onError].
  Exception _onShaderError(String path, Error e) {
    Exception notFoundError =
        new Exception('Shader not found on path \"${path}\"');
    _onErrorCtrl.add(new ResourceErrorEvent(path, notFoundError));
    return new Exception(notFoundError);
  }

  Stream<ResourceLoadEvent> get onLoad => _onLoadCtrl.stream;

  Stream<ResourceErrorEvent> get onError => _onErrorCtrl.stream;

  Stream<ResourceProgressEvent> get onProgress => _onProgressCtrl.stream;
}

/// Resource loading event.
class ResourceLoadEvent {
  /// Can be [ImageElement] or [String].
  dynamic resource;

  /// Resource path.
  String path;

  ResourceLoadEvent(this.path, this.resource) {}
}

/// Resource loading error.
class ResourceErrorEvent {
  Exception error;

  /// Resource path.
  String path;

  ResourceErrorEvent(this.path, this.error);
}

/// Resource progress event.
class ResourceProgressEvent {
  /// Total file size.
  int total;

  /// Loaded file size.
  int loaded;

  /// Resource path.
  String path;

  /// Is length computable or not.
  /// If [false], [total] will be equal to 0.
  bool lengthComputable;

  ResourceProgressEvent(this.path, this.loaded, this.total, this.lengthComputable);
}
