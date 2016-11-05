@TestOn('content-shell')

import 'package:test/test.dart';
import 'package:ose/ose_math.dart' show Vector3;

void main() {
  group('Vector3', () {
      test('#absolute() makes values to be absolute', () {
          Vector3 vector = new Vector3(-1.0, 1.0);
          vector.absolute();
          expect(vector, equals(new Vector3(1.0, 1.0)));
      });
  });
}
