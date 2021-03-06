library ose;

import 'dart:collection';
import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:web_gl' as webGL;

import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import 'ose_math.dart';
import 'ose_utils.dart' as utils;
import 'ose_io.dart';

part 'src/core/renderer/renderer.dart';
part 'src/core/renderer/renderer_events.dart';
part 'src/core/renderer/renderer_lifecycle_controllers.dart';
part 'src/core/renderer/renderer_settings.dart';
part 'src/core/renderer/renderer_state.dart';
part 'src/core/renderer/renderer_managers.dart';

part 'src/core/transform/camera_transform.dart';
part 'src/core/transform/transform.dart';
part 'src/core/transform/scene_object_transform.dart';

part 'src/core/camera/camera.dart';

part 'src/core/scene/scene.dart';

part 'src/core/actor/actor.dart';
part 'src/core/actor/control_actor.dart';

part 'src/core/object/scene_object.dart';
part 'src/core/object/scene_object_group.dart';
part 'src/core/object/shape/shape.dart';
part 'src/core/object/shape/rectangle.dart';
part 'src/core/object/shape/circle.dart';
part 'src/core/object/shape/triangle.dart';
part 'src/core/object/sprite/sprite.dart';

part 'src/core/filter/filter.dart';
part 'src/core/filter/basic/basic_filter.dart';
part 'src/core/filter/sprite/sprite_filter.dart';

part 'src/core/shader/attribute.dart';
part 'src/core/shader/uniform.dart';
part 'src/core/shader/shader_program.dart';
part 'src/core/shader/shader.dart';

part 'src/core/shader/basic/basic_shader_program.dart';
part 'src/core/shader/basic/frag_basic_shader.dart';
part 'src/core/shader/basic/vert_basic_shader.dart';

part 'src/core/shader/sprite/sprite_shader_program.dart';
part 'src/core/shader/sprite/frag_sprite_shader.dart';
part 'src/core/shader/sprite/vert_sprite_shader.dart';

part 'src/core/shader/qualifier_type.dart';
part 'src/core/shader/qualifier_state.dart';

part 'src/core/manager/attribute_manager.dart';
part 'src/core/manager/uniform_manager.dart';
part 'src/core/manager/shader_program_manager.dart';
part 'src/core/manager/camera_manager.dart';
part 'src/core/manager/scene_manager.dart';
part 'src/core/manager/filter_manager.dart';
part 'src/core/manager/asset_manager.dart';
part 'src/core/manager/texture_manager.dart';

part 'src/core/texture/texture.dart';
part 'src/core/texture/original_texture.dart';
part 'src/core/texture/sub_texture.dart';
part 'src/core/texture/texture_type.dart';

part 'src/core/color/color.dart';
part 'src/core/color/solid_color.dart';
part 'src/core/color/gradient_color.dart';

part 'src/core/loader/resource_loader.dart';

part 'src/core/light/light.dart';
part 'src/core/light/directional_light.dart';
part 'src/core/light/point_light.dart';
part 'src/core/light/ambient_light.dart';
