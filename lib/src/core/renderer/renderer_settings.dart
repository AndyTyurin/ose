part of ose;

class RendererSettings {
  int width;
  int height;
  int pixelRatio;
  int fpsThreshold;
  int clearColor;
  bool useTransparent;
  bool useAutoResize;
  bool useMask;
  bool useClear;
  bool useAntialias;

  /// [width] - canvas width.
  /// [height] - canvas height.
  /// [pixelRatio] - 2x for retina, 1x for custom screen.
  /// [fpsThreshold] - fps threshold. Min is 1, max is 60.
  /// [autoResize] - resize canvas on screen dimension change.
  /// [transparent] - is canvas transparent or not.
  /// [mask] - if true, gives opportunity to work with mask manager.
  /// [clearColor] - fill background with color, only if [clear] is [true].
  /// [clear] - clear color buffer on next frame.
  /// [antialias] - use antialias.
  RendererSettings(
      {int width: 800,
      int height: 600,
      int pixelRatio: 1,
      int fpsThreshold: 60,
      int clearColor,
      bool useTransparent: true,
      bool useAutoResize: false,
      bool useMask: true,
      bool useClear: true,
      bool useAntialias: true}) {
    this.width = width;
    this.height = height;
    this.pixelRatio = pixelRatio;
    this.fpsThreshold = max(1, min(60, fpsThreshold));
    this.clearColor = clearColor ?? 0;  // todo: change to Color
    this.useTransparent = useTransparent;
    this.useAutoResize = useAutoResize;
    this.useMask = useMask;
    this.useClear = useClear;
    this.useAntialias = useAntialias;
  }
}
