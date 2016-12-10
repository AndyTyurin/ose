part of ose;

class RendererManagers {
  final UniformManager uniformManager;

  final AttributeManager attributeManager;

  final ShaderProgramManager shaderProgramManager;

  final SceneManager sceneManager;

  final CameraManager cameraManager;

  final IOManager ioManager;

  RendererManagers()
      : uniformManager = new UniformManager(),
        attributeManager = new AttributeManager(),
        shaderProgramManager = new ShaderProgramManager(),
        sceneManager = new SceneManager(),
        cameraManager = new CameraManager(),
        ioManager = new IOManager();
}
