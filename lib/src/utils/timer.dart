class Timer {
  /// Timestamp.
  num _timestamp;

  /// Delta time.
  ///
  /// Time between current & previous timestamps.
  num _delta;

  Timer() {
    _timestamp = new DateTime.now().millisecondsSinceEpoch;
  }

  /// Set checkpoint.
  ///
  /// Returns [_delta] - delta time.
  num checkpoint() {
    return _delta =
        _timestamp - (_timestamp = new DateTime.now().millisecondsSinceEpoch);
  }

  num get delta => _delta;
}
