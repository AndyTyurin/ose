part of ose;

/// Attribute manager manages attributes.
class AttributeManager {
  /// Equality tool for lists.
  static final Function eq = const ListEquality().equals;

  /// Previous attributes.
  final Map<String, Attribute> prevAttributes;

  /// Current attributes.
  final Map<String, Attribute> nextAttributes;

  /// Rendering context.
  webGL.RenderingContext _gl;

  AttributeManager(this._gl)
      : prevAttributes = <String, Attribute>{},
        nextAttributes = <String, Attribute>{};

  /// Bind attributes.
  void bindAttributes(ShaderProgram shaderProgram) {
    shaderProgram.attributes.forEach((name, attribute) {
      _setActiveAttribute(name, attribute);
      _bindAttribute(shaderProgram, name, attribute);
    });
  }

  /// Generate locations for attributes that haven't them yet.
  void generateLocations(ShaderProgram shaderProgram) {
    shaderProgram.attributes.forEach((name, attribute) {
      _generateLocation(shaderProgram, name, attribute);
    });
  }

  /// Prepare each attribute in shader program.
  void prepareAttributes(ShaderProgram shaderProgram) {
    shaderProgram.attributes.forEach((name, attribute) {
      _prepareAttribute(shaderProgram, name, attribute);
    });
  }

  /// Check is attribute was changed or not.
  /// If attribute was change return [true].
  bool _shouldBindAttribute(String name) {
    return prevAttributes[name] != nextAttributes[name];
  }

  /// Set current attribute to be an active.
  void _setActiveAttribute(String name, Attribute attribute) {
    prevAttributes[name] = nextAttributes[name];
    nextAttributes[name] = attribute;
  }

  /// Bind attribute to shader program.
  void _bindAttribute(
      ShaderProgram shaderProgram, String name, Attribute attribute) {
    bool shouldBindBuffer = _shouldBindAttribute(name);

    if (!shouldBindBuffer && attribute.state == QualifierState.CACHED) return;

    int attributeLocation = attribute.location;
    bool useBuffer = attribute.useBuffer;
    List attributeStorage = attribute.storage;
    int attributeSize = 1;

    switch (attribute.type) {
      case QualifierType.Float1:
        if (useBuffer) break;
        _gl.vertexAttrib1f(attributeLocation, attributeStorage[0]);
        break;
      case QualifierType.Float2:
        if (useBuffer) {
          attributeSize = 2;
          break;
        }
        _gl.vertexAttrib2f(
            attributeLocation, attributeStorage[0], attributeStorage[1]);
        break;
      case QualifierType.Float3:
        if (useBuffer) {
          attributeSize = 3;
          break;
        }
        _gl.vertexAttrib3f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2]);
        break;
      case QualifierType.Float4:
        if (useBuffer) {
          attributeSize = 4;
          break;
        }
        _gl.vertexAttrib4f(attributeLocation, attributeStorage[0],
            attributeStorage[1], attributeStorage[2], attributeStorage[3]);
        break;
      default:
        ;
    }

    if (attribute.useBuffer) {
      _gl.bindBuffer(webGL.ARRAY_BUFFER, attribute.buffer);

      if (attribute.state == QualifierState.CHANGED) {
        _gl.enableVertexAttribArray(attributeLocation);
        _gl.vertexAttribPointer(
            attributeLocation, attributeSize, webGL.FLOAT, false, 0, 0);
        _gl.bufferData(
            webGL.ARRAY_BUFFER, attribute.storage, webGL.STATIC_DRAW);
      }
    }
  }

  /// Generate location for specific attribute.
  void _generateLocation(
      ShaderProgram shaderProgram, String name, Attribute attribute) {
    if (attribute.location == null) {
      attribute.location = _gl.getAttribLocation(shaderProgram.glProgram, name);
    }
  }

  /// Prepare attribute.
  /// Binds attribute location if it was set (before shader program linking) and
  /// create buffer for each of attribute.
  void _prepareAttribute(
      ShaderProgram shaderProgram, String name, Attribute attribute) {
    if (attribute.location != null) {
      _gl.bindAttribLocation(shaderProgram.glProgram, attribute.location, name);
    }
    if (attribute.useBuffer && attribute.buffer == null) {
      attribute.buffer = _gl.createBuffer();
    }
  }
}
