@TestOn('content-shell')

import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:ose/ose_math.dart' show Vector2;

void main() {
  group('Vector2', () {
      test('#absolute makes values to be absolute', () {
          Vector2 vector = new Vector2(-1.0, 1.0);
          vector.absolute();
          expect(vector, equals(new Vector2(1.0, 1.0)));
      });

      test('#rotate rotates by 90 degrees (PI / 2)', () {
          Vector2 vector = new Vector2(0.0, 1.0);
          vector.rotate(math.PI / 2);
          expect(vector, equals(new Vector2(1.0, .0)));
          vector.rotate(math.PI / 2);
          expect(vector, equals(new Vector2(0.0, -1.0)));
          vector.rotate(math.PI / 2);
          expect(vector == new Vector2(-1.0, 0.0), equals(true));
          vector.rotate(math.PI / 2);
          expect(vector == new Vector2(0.0, 1.0), equals(true));
          vector.rotate(-math.PI / 2);
          expect(vector == new Vector2(-1.0, 0.0), equals(true));
      });
  });
}
