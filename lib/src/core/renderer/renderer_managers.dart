part of ose;

/// It keeps references to different managers of the renderer.
class RendererManagers {
  /// Manages shader programs.
  final ShaderProgramManager shaderProgramManager;

  /// Manages scenes.
  final SceneManager sceneManager;

  /// Manages cameras.
  final CameraManager cameraManager;

  /// Manages input controllers such as keyboard, mouse & touch.
  final IOManager ioManager;

  /// Manages filters.
  final FilterManager filterManager;

  /// Manages resources.
  final AssetManager assetManager;

  /// Manages textures.
  final TextureManager textureManager;

  RendererManagers(webGL.RenderingContext gl,
      {void onFilterRegister(FilterRegisterEvent e),
      void onTextureRegister(TextureRegisterEvent e)})
      : shaderProgramManager = new ShaderProgramManager(),
        sceneManager = new SceneManager(),
        cameraManager = new CameraManager(),
        ioManager = new IOManager(),
        filterManager = new FilterManager(gl),
        assetManager = new AssetManager(
            onFilterRegister: onFilterRegister,
            onTextureRegister: onTextureRegister),
        textureManager = new TextureManager(gl);
}
