@TestOn('content-shell')

import 'package:test/test.dart';
import 'package:ose/ose_math.dart' show Vector4;

void main() {
  group('Vector4', () {
      test('#absolute makes values to be absolute', () {
          Vector4 vector = new Vector4(-1.0, 1.0, -1.0, 1.0);
          vector.absolute();
          expect(vector, equals(new Vector4(1.0, 1.0, 1.0, 1.0)));
      });
  });
}
