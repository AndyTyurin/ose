import './../../shader.dart';
import 'dart:async';

Future<ShaderProgram> createBasicShaderProgram(ShaderProgramManager spm) {
  return spm.create('basic_0', 'basic_v_shader.glsl', 'basic_f_shader.glsl');
}