part of ose_utils;

/// Timer.
/// Used to calculate delta time between two checkpoints.
/// Use [checkpoint] to make new one and [delta] to get delta time
/// between two checkpoints.
class Timer {
  /// Previous time since render start in milliseconds.
  num _prevTime;

  /// Current time since render start in milliseconds.
  num _currentTime;

  /// Time accumulator.
  num _accumulator;

  /// Create timer.
  Timer() {
    _currentTime = 0;
    _prevTime = 0;
    _accumulator = 0;
  }

  /// Initialize timer.
  void init() {
    resetAccumulator();
  }

  /// Set checkpoint.
  /// Set up current & past times since render start and accumulate delta time.
  void checkpoint(num millisecondsSinceRenderStart) {
    _prevTime = _currentTime;
    _currentTime = millisecondsSinceRenderStart;
    _accumulator += delta;
  }

  /// Subtract accumulator.
  void subtractAccumulator(num subtraction) {
    _accumulator -= subtraction;
  }

  /// Reset accumulator.
  void resetAccumulator() {
    _accumulator = 0;
  }

  /// Delta time between two checkpoints.
  int get delta => _currentTime - _prevTime;

  num get accumulator => _accumulator;
}
