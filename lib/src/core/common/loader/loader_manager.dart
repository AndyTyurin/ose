part of ose;

class LoaderManager {
  /// Cached files.
  Map<String, dynamic> _files;

  /// Used to keep tracking of loading files.
  Function onProgress = (_) {};

  /// Catches by [load] if error occurred.
  Function onError = (_) {};

  /// On file load.
  Function onLoad = (_) {};

  /// Create new loader manager.
  LoaderManager() {
    _files = <String, dynamic>{};
  }

  /// Load file.
  ///
  /// [path] is path to file.
  /// [force] if [true] re-writes cache.
  Future<dynamic> load(String path, [bool force]) async {
    Completer completer = new Completer();

    // Take from cache.
    if (force && _files[path] != null) {
      return completer
        ..complete(_files[path])
        ..future;
    }

    String extension = _getPathFileExtension(path);
    bool isImageExtension = _isImageExtension(extension);
    String responseType = (isImageExtension) ? 'blob' : 'text';

    HttpRequest
        .request(path, responseType: responseType, onProgress: onProgress)
        .then((HttpRequest req) {
      // [Blob] or [String] type.
      dynamic response = req.response;
      if (isImageExtension) {
        // Handle image extension.
        FileReader reader = new FileReader();
        reader.onLoad.listen((_) {
          ImageElement img = new ImageElement();
          img.src = reader.result;
          img.onLoad.listen((_) => completer.complete(img));
        });
        reader.readAsDataUrl(response);
      } else {
        // Handle other extensions as text format.
        completer.complete(response);
      }
    }).catchError(onError);

    return completer.future.then((content) {
      onLoad(_files[path] = content);
      return content;
    });
  }

  /// Get file extension by given path.
  static String _getPathFileExtension(String path) {
    return path.split('.')[1];
  }

  /// Return [true] if there is an image extension.
  static bool _isImageExtension(String extension) {
    return extension == 'jpg' || extension == 'jpeg' || extension == 'png';
  }

  Map<String, dynamic> get files => _files;
}
