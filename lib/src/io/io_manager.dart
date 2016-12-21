part of ose_io;

/// It keeps references to [KeyboardController], [MouseController],
/// [TouchController].
class IOManager {
  /// Used to check keyboard events.
  final KeyboardController keyboard;

  /// Used to check mouse events.
  final MouseController mouse;

  /// Used to check touch events.
  final TouchController touch;

  IOManager()
      : keyboard = new KeyboardController(),
        mouse = new MouseController(),
        touch = new TouchController();

  /// Updates our controllers.
  /// Renderer invokes method directly.
  void update() {
    mouse.update();
  }

  /// Binds controllers.
  void bind() {
    keyboard.bind();
    mouse.bind();
    touch.bind();
  }

  /// Set off controllers.
  void unbind() {
    keyboard.unbind();
    mouse.unbind();
  }
}
