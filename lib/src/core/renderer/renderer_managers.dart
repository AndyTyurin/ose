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

  /// Manages resources.
  final AssetManager assetManager;

  /// Manages textures.
  final TextureManager textureManager;

  RendererManagers(webGL.RenderingContext gl,
      {void onTextureRegister(TextureRegisterEvent e)})
      : shaderProgramManager = new ShaderProgramManager(gl),
        sceneManager = new SceneManager(),
        cameraManager = new CameraManager(),
        ioManager = new IOManager(),
        assetManager = new AssetManager(
            onTextureRegister: onTextureRegister),
        textureManager = new TextureManager(gl);
}
