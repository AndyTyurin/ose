part of ose;

/// Different renderer settings.
class RendererSettings {
  /// Canvas width.
  int width;

  /// Canvas height.
  int height;

  /// FPS threshold from 1 to 60.
  int fpsThreshold;

  /// Which color will be used to dispose window.
  int clearColor;

  /// Use transparent graphics such as png textures.
  bool useTransparent;

  /// Use masking on renderer. (Still not working).
  bool useMask;

  /// Use clear or not.
  bool useClear;

  /// Use antialisasing on rendering.
  bool useAntialias;

  /// Canvas will be on full screen or not.
  bool fullscreen;

  RendererSettings(
      {int width: 800,
      int height: 600,
      int fpsThreshold: 60,
      int clearColor: 0x000000,
      bool fullscreen: false,
      bool useTransparent: true,
      bool useMask: true,
      bool useClear: true,
      bool useAntialias: true}) {
    this.width = width;
    this.height = height;
    this.fullscreen = fullscreen;
    this.fpsThreshold = max(1, min(60, fpsThreshold));
    this.clearColor = clearColor ?? 0; // todo: change to Color
    this.useTransparent = useTransparent;
    this.useMask = useMask;
    this.useClear = useClear;
    this.useAntialias = useAntialias;
  }
}
