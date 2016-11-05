@TestOn('content-shell')
import 'package:test/test.dart';
import 'package:ose/ose_utils.dart' show generateUuid;

void main() {
  test('#generateUuid() UUID has 36 characters', () {
    expect(generateUuid().length, 36);
  });
}
