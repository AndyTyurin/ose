library ose_webgl;

import 'dart:html';
import 'dart:async';
import 'dart:typed_data';
import 'dart:web_gl' as webGL;
import 'dart:math' as math;

import 'ose.dart' as ose;
import 'ose_math.dart';
import 'ose_utils.dart' as utils;

part 'src/core/webgl/renderer/webgl_renderer.dart';
part 'src/core/webgl/renderer/webgl_renderer_settings.dart';
part 'src/core/webgl/filter/filter.dart';
part 'src/core/webgl/filter/shape/shape_filter.dart';
part 'src/core/webgl/filter/particles/particles_filter.dart';
part 'src/core/webgl/gameobject/shape/shape.dart';
part 'src/core/webgl/gameobject/shape/rectangle.dart';
part 'src/core/webgl/gameobject/shape/triangle.dart';
part 'src/core/webgl/gameobject/shape/circle.dart';
part 'src/core/webgl/gameobject/particles/particles.dart';
part 'src/core/webgl/shader/shader.dart';
part 'src/core/webgl/shader/shader_program.dart';
part 'src/core/webgl/shader/shader_program_manager.dart';
part 'src/core/webgl/shader/attribute.dart';
part 'src/core/webgl/shader/uniform.dart';
part 'src/core/webgl/shader/shape/vert_shape_shader.dart';
part 'src/core/webgl/shader/shape/frag_shape_shader.dart';
part 'src/core/webgl/shader/shape/shape_shader_program.dart';
part 'src/core/webgl/shader/particles/vert_particles_shader.dart';
part 'src/core/webgl/shader/particles/frag_particles_shader.dart';
part 'src/core/webgl/shader/particles/particles_shader_program.dart';
part 'src/core/webgl/texture/texture.dart';
