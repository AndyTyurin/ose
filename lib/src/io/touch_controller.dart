part of ose_io;

class TouchController {
  static TouchController _touch = new TouchController._internal();

  static num sensitive = .75;

  Touch _lastTouchAction;

  Touch _prevTouchAction;

  TouchController._internal() {}

  factory TouchController() => _touch;

  void update() {}

  void bind() {
    window.addEventListener('touchstart', _registerEvent, false);
    window.addEventListener('touchend', _unregisterEvent, false);
    window.addEventListener('touchmove', _registerMoveEvent, false);
  }

  void unbind() {
    window.removeEventListener('touchstart', _registerEvent, false);
    window.removeEventListener('touchend', _unregisterEvent, false);
    window.removeEventListener('touchmove', _registerMoveEvent, false);
  }

  void _registerEvent(TouchEvent e) {
    e.preventDefault();
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
    e.preventDefault();
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

  get movedBottom => (movement?.y ?? 0) < ((sensitive > 0) ? -1 / sensitive : 0);

  get movedLeft => (movement?.x ?? 0) < ((sensitive > 0) ? -1 / sensitive : 0);

  get movedRight => (movement?.x ?? 0) > ((sensitive > 0) ? 1 / sensitive : 0);
}
