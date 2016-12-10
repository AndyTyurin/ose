part of ose_io;

class IOManager {
  final KeyboardController keyboard;
  final MouseController mouse;
  final TouchController touch;

  IOManager()
      : keyboard = new KeyboardController(),
        mouse = new MouseController(),
        touch = new TouchController();

  void update() {
    mouse.update();
    touch.update();
  }

  void bind() {
    keyboard.bind();
    mouse.bind();
    touch.bind();
  }

  void unbind() {
    keyboard.unbind();
    mouse.unbind();
  }
}
