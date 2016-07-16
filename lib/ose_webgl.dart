library ose_webgl;

import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:web_gl' as webGL;

import 'ose.dart' as ose;
import 'ose_math.dart' as math;
import 'ose_utils.dart' as utils;

part 'src/core/webgl/renderer/webgl_renderer.dart';
part 'src/core/webgl/filter/filter.dart';
part 'src/core/webgl/gameobject/rectangle.dart';
part 'src/core/webgl/gameobject/triangle.dart';
part 'src/core/webgl/gameobject/circle.dart';
part 'src/core/webgl/shader/shader.dart';
part 'src/core/webgl/shader/shader_manager.dart';
part 'src/core/webgl/shader/shader_program.dart';
part 'src/core/webgl/shader/shader_program_manager.dart';
part 'src/core/webgl/shader/attribute.dart';
part 'src/core/webgl/shader/uniform.dart';
