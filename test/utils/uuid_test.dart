@TestOn('vm')

import 'package:test/test.dart';

import 'package:ose/ose_utils.dart';

void main() {
	test('Generates UUID', () {
		expect(generateUuid(), allOf([
			contains('b'),
			contains('a'),
			hasLength(36)
		]));
	});
}
