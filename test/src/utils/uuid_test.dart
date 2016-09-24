@TestOn('browser')

import 'package:test/test.dart';
import 'package:ose/ose_utils.dart';

void main() {
  group('generateUuid()', () {
      test('UUID has 36 characters', () {
          expect(generateUuid().length, 36);
      });
  });
}
