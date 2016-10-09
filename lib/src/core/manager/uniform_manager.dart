part of ose;

class UniformManager {
  static final Function eq = const ListEquality().equals;

  final Map<String, Uniform> prevUniforms;

  final Map<String, Uniform> nextUniforms;

  UniformManager()
      : prevUniforms = <String, Uniform>{},
        nextUniforms = <String, Uniform>{};

  bool shouldBindUniform(String name) {
    return prevUniforms[name] != nextUniforms[name];
  }

  void setActiveUniform(String name, Uniform uniform) {
    prevUniforms[name] = nextUniforms[name];
    nextUniforms[name] = uniform;
  }
}
