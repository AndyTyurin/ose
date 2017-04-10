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

  /// Max lights.
  int maxLights;

  /// Use alpha for canvas.
  bool useAlpha;

  /// Use masking on renderer. (Still not working).
  bool useMask;

  /// Use depth buffer.
  bool useDepth;

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
      int maxLight: 4,
      bool fullscreen: false,
      bool useAlpha: false,
      bool useMask: true,
      bool useDepth: false,
      bool useClear: true,
      bool useAntialias: true}) {
    this.width = width;
    this.height = height;
    this.fullscreen = fullscreen;
    this.fpsThreshold = max(1, min(60, fpsThreshold));
    this.clearColor = clearColor ?? 0; // todo: change to Color
    this.maxLights = maxLights;
    this.useAlpha = useAlpha;
    this.useMask = useMask;
    this.useDepth = useDepth;
    this.useClear = useClear;
    this.useAntialias = useAntialias;
  }
}
