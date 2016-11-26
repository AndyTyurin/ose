@TestOn('content-shell')
import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:ose/ose_math.dart';
import 'package:ose/ose.dart' show Transform;

class TransformImpl extends Transform {
  TransformImpl({Vector2 position, double rotation})
      : super(rotation: rotation, position: position);
}

void main() {
  group('Transform', () {
    test('#Transform should create a new transform with default values', () {
      TransformImpl transform = new TransformImpl();
      Matrix3 identityMat = new Matrix3.identity();
      Vector2 defaultPos = Transform.defaultPosition;
      double defaultRot = .0;
      expect(transform.position, equals(defaultPos));
      expect(transform.rotation, equals(defaultRot));
      expect(transform.rotationMatrix, equals(identityMat));
      expect(transform.translationMatrix, equals(identityMat));
    });

    test('#updateRotationMatrix should update rotation matrix', () {
      TransformImpl transform = new TransformImpl();
      transform.rotation += math.PI / 2;
      transform.updateRotationMatrix();
      Matrix rotMatrix =
          new Matrix3.fromValues(.0, -1.0, .0, 1.0, .0, .0, .0, .0, 1.0);
      expect(transform.rotationMatrix, equals(rotMatrix));
    });

    test('#updateRotationMatrix should update forward vector', () {
      TransformImpl transform = new TransformImpl();
      transform.rotation += math.PI / 2;
      transform.updateRotationMatrix();
      Vector2 forward = new Vector2(1.0, .0);
      expect(transform.forward, equals(forward));
    });

    test('#updateTranslationMatrix should update translation matrix', () {
      TransformImpl transform = new TransformImpl();
      transform.position.x += 1.0;
      transform.updateTranslationMatrix();
      Matrix3 translationMatrix = new Matrix3.identity();
      translationMatrix.m20 = 1.0;
      expect(transform.translationMatrix, equals(translationMatrix));
    });

    test('#copyFrom should copy all properties from another transform', () {
      TransformImpl transform = new TransformImpl();
      Vector2 position = new Vector2(1.0, 0.0);
      double rotation = math.PI;
      TransformImpl anotherTransform =
          new TransformImpl(position: position, rotation: rotation);
      transform.copyFrom(anotherTransform);
      expect(transform.position, equals(position));
      expect(transform.rotation, equals(rotation));
    });
  });
}
