part of ose_io;

/// IO manager.
/// It controls all available input controllers, updates their states when new
/// rendering cycle occurs.
///
/// Has been used internally by game engine. To use in game implementation,
/// [InputControllers] can be used instead.
/// Input controllers are available in actor's while updating.
/// Look at [Actor] interface to get more about it.
class IOManager {
  final InputControllers inputControllers;

  IOManager()
      : inputControllers = new InputControllers();

  /// Updates our controllers.
  /// Renderer invokes method directly.
  void update() {
    inputControllers.mouse.update();
  }

  /// Binds controllers.
  void bind() {
    inputControllers.keyboard.bind();
    inputControllers.mouse.bind();
    inputControllers.touch.bind();
  }

  /// Set off controllers.
  void unbind() {
    inputControllers.keyboard.unbind();
    inputControllers.mouse.unbind();
  }
}
