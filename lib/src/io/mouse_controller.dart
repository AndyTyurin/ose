part of ose_io;

class MouseController {
  static MouseController _mouse = new MouseController._internal();

  static num sensitive = .75;

  Queue<MouseEvent> _pressedEvents;
  MouseEvent _moveEvent;

  MouseController._internal() {
    _pressedEvents = new Queue<MouseEvent>();
  }

  factory MouseController() => _mouse;

  bool pressed(int button,
      {bool shift: false,
      bool ctrl: false,
      bool alt: false,
      bool meta: false}) {
    MouseEvent event = _pressedEvents.firstWhere(
        (event) => _isEventEqualsTo(event, button,
            shift: shift, ctrl: ctrl, alt: alt, meta: meta),
        orElse: () => null);
    return event != null;
  }

  void update() {
    _moveEvent = null;
  }

  void bind() {
    window.addEventListener('mousedown', _registerEvent, false);
    window.addEventListener('mousemove', _registerMoveEvent, false);
    window.addEventListener('mouseup', _unregisterEvent, false);
  }

  void unbind() {
    window.removeEventListener('mousedown', _registerEvent, false);
    window.removeEventListener('mousemove', _registerMoveEvent, false);
    window.removeEventListener('mouseup', _unregisterEvent, false);
    _pressedEvents.clear();
  }

  void _registerEvent(MouseEvent e) {
    e.preventDefault();
    _pressedEvents.addFirst(e);
  }

  void _registerMoveEvent(MouseEvent e) {
    e.preventDefault();
    _moveEvent = e;
  }

  void _unregisterEvent(MouseEvent e) {
    _pressedEvents.removeWhere((event) => _isEventEqualsTo(event, e.button,
        shift: e.shiftKey, ctrl: e.ctrlKey, alt: e.altKey, meta: e.metaKey));
  }

  bool _isEventEqualsTo(MouseEvent firstEvent, int button,
      {bool shift: false,
      bool ctrl: false,
      bool alt: false,
      bool meta: false}) {
    return firstEvent.button == button &&
        firstEvent.shiftKey == shift &&
        firstEvent.ctrlKey == ctrl &&
        firstEvent.altKey == alt &&
        firstEvent.metaKey == meta;
  }

  get movement => _moveEvent?.movement;

  get position => _moveEvent?.client;

  get movedTop => (_moveEvent?.movement?.y ?? 0) > 1 / sensitive;

  get movedBottom => (_moveEvent?.movement?.y ?? 0) < -1 / sensitive;

  get movedLeft => (_moveEvent?.movement?.x ?? 0) < -1 / sensitive;

  get movedRight => (_moveEvent?.movement?.x ?? 0) > 1 / sensitive;
}
