part of ose_io;

class KeyboardController {
  static KeyboardController _keyboard = new KeyboardController._internal();

  Queue<KeyboardEvent> _pressedEvents;

  KeyboardController._internal() {
    _pressedEvents = new Queue<KeyboardEvent>();
  }

  factory KeyboardController() => _keyboard;

  bool pressed(int code,
      {bool shift: false,
      bool ctrl: false,
      bool alt: false,
      bool meta: false}) {
    KeyboardEvent event = _pressedEvents.firstWhere(
        (event) => _isEventEqualsTo(event, code,
            shift: shift, ctrl: ctrl, alt: alt, meta: meta),
        orElse: () => null);
    return event != null;
  }

  void bind() {
    window.addEventListener('keydown', _registerEvent, false);
    window.addEventListener('keyup', _unregisterEvent, false);
  }

  void unbind() {
    window.removeEventListener('keydown', _registerEvent, false);
    window.removeEventListener('keyup', _unregisterEvent, false);
    _pressedEvents.clear();
  }

  void _registerEvent(KeyboardEvent e) {
    e.preventDefault();
    _pressedEvents.addFirst(e);
  }

  void _unregisterEvent(KeyboardEvent e) {
    _pressedEvents.removeWhere((event) => _isEventEqualsTo(event, e.keyCode,
        shift: e.shiftKey, ctrl: e.ctrlKey, alt: e.altKey, meta: e.metaKey));
  }

  bool _isEventEqualsTo(KeyboardEvent firstEvent, int code,
      {bool shift: false,
      bool ctrl: false,
      bool alt: false,
      bool meta: false}) {
    return firstEvent.keyCode == code &&
        firstEvent.shiftKey == shift &&
        firstEvent.ctrlKey == ctrl &&
        firstEvent.altKey == alt &&
        firstEvent.metaKey == meta;
  }
}
