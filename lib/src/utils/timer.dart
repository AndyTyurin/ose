part of ose_utils;

/// Timer.
///
/// Used to calculate delta time between checkpoints.
/// Use [checkpoint] to make new one and [delta] to get delta time
/// between two checkpoints.
///
/// Mainly used in renderer.
class Timer {

  int _prevDeltaTimeMs;

  /// Time accumulator.
  ///
  /// Sum delta times until it will be reset by [reset]
  int _accumulator;

  int _delta;

  Timer() {
    _delta = 0;
    _prevDeltaTimeMs = 0;
    _accumulator = 0;
  }

  /// Set checkpoint with current delta time stamp.
  int checkpoint() {
    int currentTimeMs = new DateTime.now().millisecondsSinceEpoch;
    _delta = currentTimeMs - _prevDeltaTimeMs;
    _prevDeltaTimeMs = currentTimeMs;
    _accumulator += delta;
    return _delta;
  }

  void reset(int subtraction) {
    _accumulator -= subtraction;
  }

  void flush() {
    _accumulator = 0;
  }

  int get delta => _delta;

  num get accumulator => _accumulator;
}
