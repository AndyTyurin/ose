part of ose;

class Renderer {
  final RendererLifecycleControllers lifecycleControllers;

  final RendererSettings settings;

  final utils.Timer timer;

  final RendererManagers managers;

  webGL.RenderingContext gl;

  CanvasElement canvas;

  RendererState _rendererState;

  double _dt;

  Renderer({CanvasElement canvas, RendererSettings settings})
      : timer = new utils.Timer(),
        lifecycleControllers = new RendererLifecycleControllers(),
        settings = settings ?? new RendererSettings(),
        managers = new RendererManagers() {
    this.canvas = canvas ?? new CanvasElement();
    gl = this._initWebGL(this.canvas);
    _rendererState = RendererState.Stopped;
    updateViewport(settings.width, settings.height, settings.pixelRatio);
  }

  Future start() async {
    _rendererState = RendererState.StartRequested;

    // Initialize timer.
    timer.init();

    await lifecycleControllers.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    _rendererState = RendererState.Started;

    window.animationFrame.then(_render);
  }

  Future stop() async {
    _rendererState = RendererState.StopRequested;

    await lifecycleControllers.onStopCtrl
      ..add(new StopEvent(this))
      ..done;

    _rendererState = RendererState.Stopped;
  }

  Future _render(num msSinceRendererStart) async {
    if (_rendererState != RendererState.StopRequested) {
      window.animationFrame.then(_render);

      double fpsThresholdPerFrame = 1000 / settings.fpsThreshold;

      timer.checkpoint(msSinceRendererStart);

      // Skip frame if fps threshold has been reached.
      if (timer.accumulator >= fpsThresholdPerFrame) {
        timer.subtractAccumulator(fpsThresholdPerFrame);

        _dt = (timer.delta > fpsThresholdPerFrame)
            ? timer.delta
            : fpsThresholdPerFrame;
        // Pre-render scene.
        await lifecycleControllers.onRenderCtrl
          ..add(new RenderEvent(managers.sceneManager.activeScene,
              managers.cameraManager.activeCamera, this))
          ..done;

        /// Render scene.
        await _renderScene(scene, camera);

        // Post-render scene.
        await lifecycleControllers.onPostRenderCtrl
          ..add(new PostRenderEvent(scene, camera, this))
          ..done;
      }
    }
  }

  Future _renderScene(Scene scene, Camera camera) async {
    // Create clear mask.
    int clearMask = 0x00;

    // Mask to clear color buffer.
    if (settings.useClear) {
      clearMask |= webGL.COLOR_BUFFER_BIT;
    }

    // Mask to clear stencil buffer.
    if (settings.useMask) {
      clearMask |= webGL.STENCIL_BUFFER_BIT;
    }

    // Clear buffers by defined mask.
    if (clearMask > 0x00) {
      gl.clear(clearMask);
    }

    if (scene == null) {
      throw 'Scene is not defined.';
    }

    if (camera == null) {
      throw 'Camera is not defined.';
    }

    for (SceneObject obj in scene.children) {
      /// Per object pre-render.
      await lifecycleControllers.onObjectRenderCtrl
        ..add(new ObjectRenderEvent(obj, scene, camera, this))
        ..done;

      /// Render object.
      _renderObject(obj, scene, camera);

      /// Per object post-render.
      await lifecycleControllers.onObjectPostRenderCtrl
        ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
        ..done;
    }
  }

  void _renderObject(SceneObject sceneObject, Scene scene, Camera camera) {
    if (sceneObject is Shape) {
      sceneObject.rebuildColors();
    }

    sceneObject.transform.updateModelMatrix();
    camera.transform.updateProjectionMatrix();
    if (settings.useMask) {
      /// TODO: Check how could be use mask manager.
      /// this.maskManager(gameObject, maskObject, MaskManager.intersect);
      /// this.maskManager(gameObject, maskObject, MaskManager.subtract);
      /// this.maskManager.subtract(gameObject, maskObject);
      /// this.maskManager.intersect(gameObject, maskObject);
    }

    if (sceneObject is Sprite) {
      Texture texture = sceneObject.texture;

      if (texture.glTexture == null) {
        _prepareTexture(texture);
      }
    }

    // Prepare to use, apply filter values & bind filter.
    _prepareFilter(sceneObject.filter);
    sceneObject.filter.apply(sceneObject, scene, camera);
    _bindFilter(sceneObject.filter);

    if (sceneObject is Sprite) {
      if (sceneObject.hasTexture) {
        _bindTexture(sceneObject.texture);
      }
    }

    // TODO: Further we shall render groups.
    gl.drawArrays(webGL.TRIANGLE_STRIP, 0,
        (sceneObject as dynamic).glVertices.length ~/ 2);
  }

  /// Set canvas width & height.
  setCanvasSize(int width, int height, [int pixelRatio = 1]) {
    canvas.width ??= (width * pixelRatio);
    canvas.height ??= (height * pixelRatio);
  }

  /// Create WebGL rendering context.
  webGL.RenderingContext _createRenderingContext(CanvasElement canvas) {
    return canvas.getContext3d(
        alpha: settings.useTransparent,
        premultipliedAlpha: settings.useTransparent,
        antialias: settings.useAntialias,
        stencil: settings.useMask,
        preserveDrawingBuffer: settings.useClear);
  }

  /// Initialize WebGL.
  webGL.RenderingContext _initWebGL(CanvasElement canvas) {
    webGL.RenderingContext gl = _createRenderingContext(canvas);

    if (gl == null) throw 'WebGL is not supported';

    // Disable depth.
    gl.disable(webGL.DEPTH_TEST);

    // Enable stencil buffer usage.
    if (settings.useMask) {
      gl.enable(webGL.STENCIL_TEST);
    }

    // Enable blending.
    if (settings.useTransparent) {
      gl.enable(webGL.BLEND);
      gl.blendFunc(webGL.SRC_ALPHA, webGL.ONE_MINUS_SRC_ALPHA);
    }

    // Clear with color.
    if (settings.useClear) {
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      gl.clear(webGL.COLOR_BUFFER_BIT);
    }

    return gl;
  }

  void updateViewport(int width, int height, [int pixelRatio = 1]) {
    canvas.width ??= width * pixelRatio;
    canvas.height ??= height * pixelRatio;
    gl.viewport(0, 0, canvas.width, canvas.height);
  }

  void _prepareTexture(Texture texture) {
    webGL.Texture glTexture = gl.createTexture();
    texture.glTexture = glTexture;
    gl.bindTexture(webGL.TEXTURE_2D, glTexture);
    gl.pixelStorei(webGL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, texture.image);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.LINEAR);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.LINEAR);
    gl.generateMipmap(webGL.TEXTURE_2D);
    gl.bindTexture(webGL.TEXTURE_2D, null);
  }

  void _prepareAttribute(Attribute attribute) {
    if (attribute.useBuffer && attribute.buffer == null) {
      attribute.buffer = gl.createBuffer();
    }
  }

  void _prepareShader(Shader shader) {
    int glShaderType = (shader.type == ShaderType.Vertex)
        ? webGL.VERTEX_SHADER
        : webGL.FRAGMENT_SHADER;
    shader.glShader = gl.createShader(glShaderType);
    webGL.Shader glShader = shader.glShader;
    gl.shaderSource(glShader, shader.source);
    gl.compileShader(glShader);

    // Checks shader compile status.
    if (!gl.getShaderParameter(glShader, webGL.COMPILE_STATUS)) {
      throw new Exception("Can't compile shader ${shader.type}");
    }
  }

  void _prepareShaderProgram(ShaderProgram shaderProgram) {
    if (shaderProgram.glProgram == null) {
      webGL.Program glProgram = gl.createProgram();
      shaderProgram.glProgram = glProgram;

      Shader vertexShader = shaderProgram.vertexShader;
      Shader fragmentShader = shaderProgram.fragmentShader;

      _prepareShader(vertexShader);
      _prepareShader(fragmentShader);

      gl.attachShader(glProgram, vertexShader.glShader);
      gl.attachShader(glProgram, fragmentShader.glShader);
      gl.linkProgram(glProgram);

      if (!gl.getProgramParameter(glProgram, webGL.LINK_STATUS)) {
        throw new Exception("Can't compile program");
      }
    }
  }

  void _prepareFilter(Filter filter) {
    _prepareShaderProgram(filter.shaderProgram);
    filter.attributes.forEach((_, attribute) => _prepareAttribute(attribute));
  }

  void _bindAttributes(
      ShaderProgram shaderProgram, Map<String, Attribute> attributes) {
    attributes.forEach((name, attribute) {
      _attributeManager.setActiveAttribute(name, attribute);
      _bindAttribute(shaderProgram, name, attribute);
    });
  }

  void _bindAttribute(
      ShaderProgram shaderProgram, String name, Attribute attribute) {
    webGL.Program glProgram = shaderProgram.glProgram;
    bool shouldBindBuffer = _attributeManager.shouldBindAttribute(name);

    if (!shouldBindBuffer && attribute.state == QualifierState.CACHED) return;

    if (attribute.location != null) {
      if (!attribute.isLocationBound) {
        gl.bindAttribLocation(glProgram, attribute.location, name);
        attribute.bindLocation();
      }
    } else {
      attribute.location = gl.getAttribLocation(glProgram, name);
    }

    int attributeLocation = attribute.location;
    bool useBuffer = attribute.useBuffer;
    List attributeStorage = attribute.storage;
    int attributeSize = 1;

    switch (attribute.type) {
      case QualifierType.Float1:
        if (useBuffer) break;
        gl.vertexAttrib1f(attributeLocation, attributeStorage[0]);
        break;
      case QualifierType.Float2:
        if (useBuffer) {
          attributeSize = 2;
          break;
        }
        gl.vertexAttrib2f(
            attributeLocation, attributeStorage[0], attributeStorage[1]);
        break;
      case QualifierType.Float3:
        if (useBuffer) {
          attributeSize = 3;
          break;
        }
        gl.vertexAttrib3f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2]);
        break;
      case QualifierType.Float4:
        if (useBuffer) {
          attributeSize = 4;
          break;
        }
        gl.vertexAttrib4f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2], attributeStorage[3]);
        break;
      default:
        ;
    }

    if (attribute.useBuffer) {
      gl.bindBuffer(webGL.ARRAY_BUFFER, attribute.buffer);

      if (attribute.state == QualifierState.CHANGED) {
        gl.enableVertexAttribArray(attributeLocation);
        gl.vertexAttribPointer(
            attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
        gl.bufferData(webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
      }
    }
  }

  void _bindUniforms(
      ShaderProgram shaderProgram, Map<String, Uniform> uniforms) {
    uniforms.forEach((name, uniform) {
      _uniformManager.setActiveUniform(name, uniform);
      _bindUniform(shaderProgram, name, uniform);
    });
  }

  /// Apply uniform.
  void _bindUniform(ShaderProgram shaderProgram, String name, Uniform uniform) {
    webGL.Program glProgram = shaderProgram.glProgram;
    bool shouldBindUniform = _uniformManager.shouldBindUniform(name);

    if (!shouldBindUniform && uniform.state == QualifierState.CACHED) {
      return;
    }

    if (uniform.location == null) {
      uniform.location = gl.getUniformLocation(glProgram, name);
    }

    webGL.UniformLocation uniformLocation = uniform.location;

    List uniformStorage = uniform.storage;

    switch (uniform.type) {
      case QualifierType.Int1:
        if (uniform.useArray) {
          gl.uniform1iv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform1i(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Float1:
        if (uniform.useArray) {
          gl.uniform1fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform1f(uniformLocation, uniformStorage[0]);
        break;
      case QualifierType.Float2:
        if (uniform.useArray) {
          gl.uniform2fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform2f(uniformLocation, uniformStorage[0], uniformStorage[1]);
        break;
      case QualifierType.Float3:
        if (uniform.useArray) {
          gl.uniform3fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform3f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2]);
        break;
      case QualifierType.Float4:
        if (uniform.useArray) {
          gl.uniform4fv(uniformLocation, uniformStorage);
          break;
        }
        gl.uniform4f(uniformLocation, uniformStorage[0], uniformStorage[1],
            uniformStorage[2], uniformStorage[3]);
        break;
      case QualifierType.Mat2:
        gl.uniformMatrix2fv(uniformLocation, false, uniformStorage);
        break;
      case QualifierType.Mat3:
        gl.uniformMatrix3fv(uniformLocation, false, uniformStorage);
        break;
      default:
        ;
    }
  }

  _bindFilter(Filter filter) {
    _bindShaderProgram(filter.shaderProgram);
    _bindAttributes(filter.shaderProgram, filter.attributes);
    _bindUniforms(filter.shaderProgram, filter.uniforms);
  }

  _bindShaderProgram(ShaderProgram shaderProgram) {
    if (_shaderProgram != shaderProgram) {
      _shaderProgram = shaderProgram;
      gl.useProgram(_shaderProgram.glProgram);
    }
  }

  _bindTexture(Texture texture) {
    gl.activeTexture(webGL.TEXTURE0);
    gl.bindTexture(webGL.TEXTURE_2D, texture.glTexture);
  }

  Scene get scene => managers.sceneManager.activeScene;

  void set scene(Scene scene) {
    managers.sceneManager.activeScene = scene;
  }

  Camera get camera => managers.cameraManager.activeCamera;

  void set camera(Camera camera) {
    managers.cameraManager.activeCamera = camera;
  }

  ShaderProgram get _shaderProgram =>
      managers.shaderProgramManager.activeShaderProgram;

  AttributeManager get _attributeManager => managers.attributeManager;

  UniformManager get _uniformManager => managers.uniformManager;

  void set _shaderProgram(ShaderProgram shaderProgram) {
    managers.shaderProgramManager.activeShaderProgram = shaderProgram;
  }

  RendererState get state => _rendererState;

  Stream<StartEvent> get onStart => lifecycleControllers.onStartCtrl.stream;

  Stream<StopEvent> get onStop => lifecycleControllers.onStopCtrl.stream;

  Stream<RenderEvent> get onRender => lifecycleControllers.onRenderCtrl.stream;

  Stream<PostRenderEvent> get onPostRender =>
      lifecycleControllers.onPostRenderCtrl.stream;

  Stream<ObjectRenderEvent> get onObjectRender =>
      lifecycleControllers.onObjectRenderCtrl.stream;

  Stream<ObjectPostRenderEvent> get onObjectPostRender =>
      lifecycleControllers.onObjectPostRenderCtrl.stream;

  double get dt => _dt;

  int get fps => 1000 ~/ dt;
}
