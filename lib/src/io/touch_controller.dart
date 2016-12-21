part of ose_io;

/// Touch
class TouchController {
  static TouchController _touch = new TouchController._internal();

  /// Mouse sensitive.
  static num sensitive = .75;

  /// Will be used in touch event subscription.
  Element element;

  /// Last touch action (only one finger).
  Touch _lastTouchAction;

  /// Previous touch action (ony one finger).
  Touch _prevTouchAction;

  TouchController._internal() {}

  factory TouchController() => _touch;

  /// Bind touch controller.
  void bind() {
    element = element ?? window;
    element.addEventListener('touchstart', _registerEvent, false);
    element.addEventListener('touchend', _unregisterEvent, false);
    element.addEventListener('touchmove', _registerMoveEvent, false);
  }

  /// Set off touch controller.
  void unbind() {
    element.removeEventListener('touchstart', _registerEvent, false);
    element.removeEventListener('touchend', _unregisterEvent, false);
    element.removeEventListener('touchmove', _registerMoveEvent, false);
  }

  void _registerEvent(TouchEvent e) {
    if (_lastTouchAction == null) {
      _prevTouchAction = _lastTouchAction;
      _lastTouchAction = e.changedTouches[0];
    }
  }

  void _registerMoveEvent(TouchEvent e) {
    e.preventDefault();
    if (_lastTouchAction != null) {
      Touch foundTouchAction = e.changedTouches.firstWhere(
          (touch) => touch.identifier == _lastTouchAction.identifier);
      if (foundTouchAction != null) {
        _prevTouchAction = _lastTouchAction;
        _lastTouchAction = foundTouchAction;
      }
    }
  }

  void _unregisterEvent(TouchEvent e) {
    if (_lastTouchAction != null) {
      Touch foundTouchAction = e.changedTouches.firstWhere(
          (touch) => touch.identifier == _lastTouchAction.identifier);
      if (foundTouchAction != null) {
        _prevTouchAction = _lastTouchAction;
        _lastTouchAction = null;
      }
    }
  }

  get movement => (_lastTouchAction != null && _prevTouchAction != null)
      ? new Point(_lastTouchAction.client.x - _prevTouchAction.client.x,
          _lastTouchAction.client.y - _prevTouchAction.client.y)
      : null;

  get position => (_lastTouchAction != null) ? _lastTouchAction.client : null;

  get movedTop => (movement?.y ?? 0) > ((sensitive > 0) ? 1 / sensitive : 0);

  get movedBottom =>
      (movement?.y ?? 0) < ((sensitive > 0) ? -1 / sensitive : 0);

  get movedLeft => (movement?.x ?? 0) < ((sensitive > 0) ? -1 / sensitive : 0);

  get movedRight => (movement?.x ?? 0) > ((sensitive > 0) ? 1 / sensitive : 0);
}
