part of ose;

class Renderer {
  static webGL.RenderingContext gl;

  final RendererLifecycleControllers _lifecycleControllers;

  final RendererSettings _rendererSettings;

  final utils.Timer _timer;

  CanvasElement canvas;

  Camera camera;

  Scene scene;

  RendererState _rendererState;

  Renderer({CanvasElement canvas, RendererSettings rendererSettings})
      : _timer = new utils.Timer(),
        _lifecycleControllers = new RendererLifecycleControllers(),
        _rendererSettings = rendererSettings {
    this.canvas = canvas ?? new CanvasElement();
    gl = this._initWebGL(this.canvas);
    _rendererState = RendererState.Stopped;
    setCanvasDimensions(_rendererSettings.width, _rendererSettings.height,
        _rendererSettings.pixelRatio);
  }

  Future start() async {
    _rendererState = RendererState.StartRequested;

    // Initialize timer.
    _timer.init();

    await _lifecycleControllers.onStartCtrl
      ..add(new StartEvent(this))
      ..done;

    _rendererState = RendererState.Started;

    window.animationFrame.then(render);
  }

  Future stop() async {
    _rendererState = RendererState.StopRequested;

    await _lifecycleControllers.onStopCtrl
      ..add(new StopEvent(this))
      ..done;

    _rendererState = RendererState.Stopped;
  }

  Future render(num dt) async {
    if (_rendererState != RendererState.StopRequested) {
      window.animationFrame.then(render);

      _timer.checkpoint(dt);

      // Skip frame if fps threshold was reached.
      if (_timer.accumulator >= (1 / _rendererSettings.fpsThreshold)) {
        _timer.subtractAccumulator(_rendererSettings.fpsThreshold);
        return;
      }

      // Pre-render scene.
      await _lifecycleControllers.onRenderCtrl
        ..add(new RenderEvent(scene, camera, this))
        ..done;

      /// Render scene.
      await renderScene(scene, camera);

      // Post-render scene.
      await _lifecycleControllers.onPostRenderCtrl
        ..add(new PostRenderEvent(scene, camera, this))
        ..done;
    }
  }

  Future renderScene(Scene scene, Camera camera) async {
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
      if (_isObjectRenderable(obj)) {
        /// Per object pre-render.
        await _lifecycleControllers.onObjectRenderCtrl
          ..add(new ObjectRenderEvent(obj, scene, camera, this))
          ..done;

        /// Render object.
        renderObject(obj, scene, camera);

        /// Per object post-render.
        await _lifecycleControllers.onObjectPostRenderCtrl
          ..add(new ObjectPostRenderEvent(obj, scene, camera, this))
          ..done;
      }
    }
  }

  void renderObject(SceneObject sceneObject, Scene scene, Camera camera) {
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

    if ((sceneObject as dynamic).filter != null) {
      (sceneObject as dynamic).filter.apply(sceneObject, scene, camera);
    }

    // TODO: Further we shall render groups.
    gl.drawArrays(
        webGL.TRIANGLE_STRIP, 0, (sceneObject as dynamic).glVertices.length ~/ 2);
  }

  /// Set canvas width & height.
  setCanvasDimensions(int width, int height, [int pixelRatio = 1]) {
    canvas.width ??= (width * pixelRatio);
    canvas.height ??= (height * pixelRatio);
  }

  /// Check is object renderable.
  bool _isObjectRenderable(SceneObject sceneObject) {
    return true;
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

  void updateViewport() {
    camera.transform
      ..width = canvas.width
      ..height = canvas.height;
    gl.viewport(0, 0, canvas.width, canvas.height);
  }

  void _prepareTexture(Texture texture) {
    webGL.Texture glTexture = gl.createTexture();
    texture.glTexture = glTexture;
    gl.bindTexture(webGL.TEXTURE_2D, glTexture);
    gl.texImage2D(webGL.TEXTURE_2D, 0, webGL.RGBA, webGL.RGBA,
        webGL.UNSIGNED_BYTE, texture.image);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MAG_FILTER, webGL.LINEAR);
    gl.texParameteri(webGL.TEXTURE_2D, webGL.TEXTURE_MIN_FILTER, webGL.LINEAR);
    gl.generateMipmap(webGL.TEXTURE_2D);
    gl.bindTexture(webGL.TEXTURE_2D, null);
  }

  void _prepareAttribute(Attribute attribute) {
    if (attribute.useBuffer) {
      attribute.buffer = gl.createBuffer();
    }
  }

  void _prepareShader(Shader shader) {
    int glShaderType = (shader.type == webGL.VERTEX_SHADER)
        ? webGL.VERTEX_SHADER
        : webGL.FRAGMENT_SHADER;
    webGL.Shader glShader = shader.glShader;
    shader.glShader = gl.createShader(glShaderType);
    gl.shaderSource(glShader, shader.source);
    gl.compileShader(glShader);

    // Checks shader compile status.
    if (!gl.getShaderParameter(glShader, webGL.COMPILE_STATUS)) {
      throw new Exception("Can't compile"
          " ${ glShaderType } shader");
    }
  }

  void _prepareShaderProgram(ShaderProgram shaderProgram) {
    shaderProgram.attributes.values.forEach(_prepareAttribute);
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

  void _prepareFilter(Filter filter) {
    _prepareShaderProgram(filter.shaderProgram);
  }

  void _bindAttributes(ShaderProgram shaderProgram) {
    shaderProgram.attributes.forEach((name, attribute) {
      _bindAttribute(shaderProgram, name, attribute);
    });
  }

  void _bindAttribute(
      ShaderProgram shaderProgram, String name, Attribute attribute) {
    if (!attribute.isChanged) return;

    webGL.Program glProgram = shaderProgram.glProgram;

    if (attribute.location != null) {
      gl.bindAttribLocation(glProgram, attribute.location, name);
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

      if (attribute.isChanged) {
        gl.bufferData(webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
      }

      gl.enableVertexAttribArray(attributeLocation);
      gl.vertexAttribPointer(
          attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
    }

    attribute.resetChangedState();
  }

  void _bindUniforms(ShaderProgram shaderProgram) {
    shaderProgram.uniforms.forEach((name, uniform) {
      _bindUniform(shaderProgram, name, uniform);
    });
  }

  /// Apply uniform.
  void _bindUniform(ShaderProgram shaderProgram, String name, Uniform uniform) {
    if (!uniform.isChanged) return;

    webGL.Program glProgram = shaderProgram.glProgram;

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

  RendererSettings get settings => _rendererSettings;

  RendererState get state => _rendererState;

  Stream<StartEvent> get onStart => _lifecycleControllers.onStartCtrl.stream;

  Stream<StopEvent> get onStop => _lifecycleControllers.onStopCtrl.stream;

  Stream<RenderEvent> get onRender => _lifecycleControllers.onRenderCtrl.stream;

  Stream<PostRenderEvent> get onPostRender =>
      _lifecycleControllers.onPostRenderCtrl.stream;

  Stream<ObjectRenderEvent> get onObjectRender =>
      _lifecycleControllers.onObjectRenderCtrl.stream;

  Stream<ObjectPostRenderEvent> get onObjectPostRender =>
      _lifecycleControllers.onObjectPostRenderCtrl.stream;

  num get dt => _timer.delta;

  num get fps => 1000 ~/ dt;
}
