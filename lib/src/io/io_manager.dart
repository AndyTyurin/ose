part of ose_io;

/// IO manager.
/// It controls all available input controllers, updates their states when new
/// rendering cycle occurs.
///
/// Has been used internally by game engine. To use in game implementation,
/// [IOTools] can be used instead. Input tools are available in actor's while
/// updating.
/// Look at [Actor] interface to get more about it.
class IOManager {
  /// Keyboard controller to listen and handle keyboard events.
  final KeyboardController keyboard;

  /// Mouse controlller to listen and handle mouse events.
  final MouseController mouse;

  /// Touch controller to listen and handle touch events.
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
