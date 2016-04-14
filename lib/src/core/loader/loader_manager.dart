import 'dart:html';
import 'dart:async';

class LoaderManager {
  /// Used to keep tracking of loading files.
  Function onProgress = (_) {};

  /// Catches by [load] if error occurred.
  Function onError = (_) {};

  /// On file load.
  Function onLoad = (_) {};

  /// Loads file.
  ///
  /// Returns [Future<ImageElement>] if loaded file is an image or
  /// [Future<String>] in all other cases.
  Future<dynamic> load(String path) async {
    String extension = _getPathFileExtension(path);
    bool isImageExtension = _isFileExtensionImage(extension);
    String responseType = (isImageExtension) ? 'blob' : 'text';
    Completer completer = new Completer();

    HttpRequest
        .request(path, responseType: responseType, onProgress: onProgress)
        .then((HttpRequest req) {
      // [Blob] or [String] type.
      dynamic response = req.response;
      if (isImageExtension) {
        /// Handle image extension.
        FileReader reader = new FileReader();
        reader.onLoad.listen((_) {
          ImageElement img = new ImageElement();
          img.src = reader.result;
          img.onLoad.listen((_) => completer.complete(img));
        });
        reader.readAsDataUrl(response);
      } else {
        /// Handle other extensions as text format.
        completer.complete(response);
      }
    }).catchError(onError);

    return completer.future.then((content) {
      onLoad(content);
      return content;
    });
  }

  /// Get file extension by given path.
  String _getPathFileExtension(String path) {
    return path.split('.')[1];
  }

  /// Returns [true] if there is an image extension.
  bool _isFileExtensionImage(String extension) {
    return extension == 'jpg' || extension == 'jpeg' || extension == 'png';
  }
}
