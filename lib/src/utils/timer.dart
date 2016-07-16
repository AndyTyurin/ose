part of ose_utils;

/// Timer.
///
/// Used to calculate delta time between checkpoints.
/// Use [checkpoint] to make new one and [delta] to get delta time
/// between two checkpoints.
class Timer {
  /// Previous delta time in ms.
  int _prevDeltaTimeMs;

  /// Time accumulator.
  ///
  /// Sum delta times until it will be reset by [reset]
  int _accumulator;

  /// Delta time between two frames.
  int _delta;

  /// Create timer.
  Timer()
      : this._delta = 0,
        this._prevDeltaTimeMs = 0,
        this._accumulator = 0;

  /// Initialize timer.
  /// Set initial date and flush accumulator.
  void init() {
    this.checkpoint();
    this.flush();
  }

  /// Set checkpoint and return [_delta].
  /// Calculate delta time and adds it to accumulator.
  int checkpoint() {
    int currentTimeMs = new DateTime.now().millisecondsSinceEpoch;
    this._delta = currentTimeMs - this._prevDeltaTimeMs;
    this._prevDeltaTimeMs = currentTimeMs;
    this._accumulator += this._delta;
    return this._delta;
  }

  /// Subtract accumulator.
  void subtract(int subtraction) {
    _accumulator -= subtraction;
  }

  /// Flush accumulator.
  void flush() {
    _accumulator = 0;
  }

  int get delta => _delta;

  num get accumulator => _accumulator;
}
