@TestOn('vm')

import 'package:test/test.dart';

import 'package:ose/src/utils/uuid.dart';

void main() {
	test('Generates UUID', () {
		expect(generateUuid(), allOf([
			contains('b'),
			contains('a'),
			hasLength(36)
		]));
	});
}