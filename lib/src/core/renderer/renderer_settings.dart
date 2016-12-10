part of ose;

class RendererSettings {
  int width;
  int height;
  int fpsThreshold;
  int clearColor;
  bool resize;
  bool useTransparent;
  bool useMask;
  bool useClear;
  bool useAntialias;

  RendererSettings(
      {int width: 800,
      int height: 600,
      int fpsThreshold: 60,
      int clearColor: 0x000000,
      bool resize: false,
      bool useTransparent: true,
      bool useMask: true,
      bool useClear: true,
      bool useAntialias: true}) {
    this.width = width;
    this.height = height;
    this.fpsThreshold = max(1, min(60, fpsThreshold));
    this.clearColor = clearColor ?? 0;  // todo: change to Color
    this.useTransparent = useTransparent;
    this.useMask = useMask;
    this.useClear = useClear;
    this.useAntialias = useAntialias;
    this.resize = resize;
  }
}
